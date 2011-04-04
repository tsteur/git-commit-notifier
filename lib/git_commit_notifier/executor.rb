# parameters: revision1, revision 2, branch

require 'git_commit_notifier'

module GitCommitNotifier
  class Executor
    def self.run!(args)
      case args.length
      when 0
        CommitHook.show_error("You have to add a path to the config file for git-commit-notifier")
        puts "Usage:  git-commit-notifier config-script [oldrev newrev [ref]]"
      when 1
        oldrev, newrev, ref = $stdin.gets.strip.split
        CommitHook.run args.first, oldrev, newrev, ref
      when 2
        CommitHook.run args.first, args.last, args.last, ""
      when 3
        CommitHook.run args.first, args[1], args.last, ""
      else
        CommitHook.run args.first, args[1], args[2], args[3]
      end
    end
  end
end

