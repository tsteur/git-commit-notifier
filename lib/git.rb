class Git
  class << self
    def show(rev)
      `git show #{rev.strip} -w`
    end

    def log(rev1, rev2)
      `git log #{rev1}..#{rev2}`.strip
    end

    def branch_commits(treeish)
      args = Git.branch_heads - [ Git.branch_head(treeish) ]
      args.map! { |tree| "^#{tree}" }
      args << treeish
      lines = `git rev-list #{args.join(' ')}`
      lines = lines.lines if lines.respond_to?(:lines)
      lines.to_a.map { |commit| commit.chomp }
    end

    def branch_heads
      lines = `git rev-parse --branches`
      lines = lines.lines if lines.respond_to?(:lines)
      lines.to_a.map { |head| head.chomp }
    end

    def branch_head(treeish)
      `git rev-parse #{treeish}`.strip
    end

    def repo_name
      git_prefix = `git config hooks.emailprefix`.strip
      return git_prefix unless git_prefix.empty?
      dir_name = `pwd`.chomp.split("/").last.gsub(/\.git$/, '')
      return "#{dir_name}"
    end

    def mailing_list_address
      `git config hooks.mailinglist`.strip
    end
  end
end

