require 'rubygems'
require 'test/unit'
require 'mocha'

require File.dirname(__FILE__) + '/../../lib/commit_hook'
require File.dirname(__FILE__) + '/../../lib/git'

class CommitHookTest < Test::Unit::TestCase

  def test_hook_ignore_merge
    run_with_config('test/fixtures/git-notifier-ignore-merge.yml', 4) # 4 commit, one email for each of them, without merge
  end

  def test_hook_with_merge
    run_with_config('test/fixtures/git-notifier-with-merge.yml', 5) # 5 commit, one email for each of them, with merge mail
  end

  def run_with_config(config, times)
    path = File.dirname(__FILE__) + '/../fixtures/'
    Git.expects(:log).with(REVISIONS.first, REVISIONS.last).returns(read_file(path + 'git_log'))
    Git.expects(:mailing_list_address).returns('recipient@test.com')
    REVISIONS.each do |rev|
      Git.expects(:show).with(rev).returns(read_file(path + "git_show_#{rev}"))
    end
    emailer = mock('Emailer')
    Emailer.expects(:new).times(times).returns(emailer) # 4 commit, one email for each of them
    emailer.expects(:send).times(times)
    CommitHook.run config, REVISIONS.first, REVISIONS.last, 'refs/heads/master'
  end


end
