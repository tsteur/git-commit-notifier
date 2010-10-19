require 'rubygems'
require 'cgi'
require 'net/smtp'
require 'sha1'

require 'diff_to_html'
require 'emailer'
require 'git'

class CommitHook

  def self.show_error(message)
    puts "************** GIT NOTIFIER PROBLEM *******************"
    puts "\n"
    puts message
    puts "\n"
    puts "************** GIT NOTIFIER PROBLEM *******************"
  end

	def self.info(message)
    $stdout.puts message 
    $stdout.flush
	end

  def self.run(config, rev1, rev2, ref_name)
    @config = {}
    @config = YAML::load_file(config) if File.exist?(config)

    project_path = Dir.getwd
    recipient = @config["mailinglist"] || Git.mailing_list_address
    
    if (recipient.nil? || recipient.length == 0)
      CommitHook.show_error(
                "Please add a recipient for the emails. Eg : \n" + 
                "      git config hooks.mailinglist  developer@example.com")
      return
    end
    
    info("Sending mail...")
    
    prefix = @config["emailprefix"] || Git.repo_name
    branch_name = "/#{ref_name.split("/").last}"

    diff2html = DiffToHtml.new(Dir.pwd, @config)
    diff2html.diff_between_revisions rev1, rev2, prefix, ref_name
    
    diffresult = diff2html.result

    if (@config["ignore_merge"])
      diffresult = diffresult.reject {|result|
        !result[:commit_info][:merge].nil?
      }
    end

    if (@config["group_email_by_push"])
      text, html = [], []
      diffresult.each_with_index do |result, i|
        text << result[:text_content]
        html << result[:html_content]
      end
      result = diffresult.first
      return if result.nil? || !result[:commit_info]

      emailer = Emailer.new(@config,
        :project_path => project_path,
        :recipient => recipient,
        :from_address => @config["from"] || result[:commit_info][:email],
        :from_alias => result[:commit_info][:author],
        :subject => "[#{prefix}#{branch_name}] #{diffresult.size > 1 ? "#{diffresult.size} commits: " : ''}#{result[:commit_info][:message]}",
        :text_message => text.join("------------------------------------------\n\n"),
        :html_message => html.join("<hr /><br />"),
        :old_rev => rev1,
        :new_rev => rev2,
        :ref_name => ref_name
      )
      emailer.send
    else
      diffresult.reverse.each_with_index do |result, i|
        next unless result[:commit_info]
        nr = number(diffresult.size, i)

        emailer = Emailer.new(@config,
          :project_path => project_path,
          :recipient => recipient,
          :from_address => @config["from"] || result[:commit_info][:email],
          :from_alias => result[:commit_info][:author],
          :subject => "[#{prefix}#{branch_name}]#{nr} #{result[:commit_info][:message]}",
          :text_message => result[:text_content],
          :html_message => result[:html_content],
          :old_rev => rev1,
          :new_rev => rev2,
          :ref_name => ref_name
        )
        emailer.send
      end
    end
  end

  def self.number(total_entries, i)
    return '' if total_entries <= 1
    digits = total_entries < 10 ? 1 : 3
    '[' + sprintf("%0#{digits}d", i + 1) + ']'
  end

end
