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
    
    puts "Sending mail..."
    STDOUT.flush
    
    prefix = @config["emailprefix"] || Git.repo_name
    branch_name = (ref_name =~ /master$/i) ? "" : "/#{ref_name.split("/").last}"

    diff2html = DiffToHtml.new(Dir.pwd)
    diff2html.diff_between_revisions rev1, rev2, prefix, ref_name
    
    diffresult = diff2html.result

    if (@config["ignore_merge"])
      diffresult = diffresult.reject {|result|
        !result[:commit_info][:merge].nil?
      }
    end
    
    diffresult.reverse.each_with_index do |result, i|
      nr = number(diffresult.size, i)
      emailer = Emailer.new @config, project_path, recipient, result[:commit_info][:email], result[:commit_info][:author],
                     "[#{prefix}#{branch_name}]#{nr} #{result[:commit_info][:message]}", result[:text_content], result[:html_content], rev1, rev2, ref_name
      emailer.send
    end
  end

  def self.number(total_entries, i)
    return '' if total_entries <= 1
    digits = total_entries < 10 ? 1 : 3
    '[' + sprintf("%0#{digits}d", i) + ']'
  end

end
