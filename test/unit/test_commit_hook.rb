require 'rubygems'
require 'test/unit'
require 'mocha'

require File.dirname(__FILE__) + '/../../lib/commit_hook'
require File.dirname(__FILE__) + '/../../lib/git'

class CommitHookTest < Test::Unit::TestCase

  def test_hook_ignore_merge
    # 4 commits, one email for each of them, without merge
    run_with_config('test/fixtures/git-notifier-ignore-merge.yml', 4)
  end

  def test_hook_with_merge
    # 5 commits, one email for each of them, with merge mail
    run_with_config('test/fixtures/git-notifier-with-merge.yml', 5)
  end

  def test_hook_group_email_by_push
    # 1 commit for the push, all commits in the one message
    run_with_config('test/fixtures/git-notifier-group-email-by-push.yml', 1)
  end

  def run_with_config(config, times)
    expect_repository_access

    emailer = mock('Emailer')
    Emailer.expects(:new).times(times).returns(emailer)
    emailer.expects(:send).times(times)
    CommitHook.run config, REVISIONS.first, REVISIONS.last, 'refs/heads/master'
  end

  def test_commit_from
    # 1 commit with a from: adress
    expect_repository_access
    emailer = mock('Emailer')
    Emailer.expects(:new).with(anything, anything, anything, "max@example.com", any_parameters).returns(emailer)
    emailer.expects(:send)
    CommitHook.run 'test/fixtures/git-notifier-group-email-by-push.yml', REVISIONS.first, REVISIONS.last, 'refs/heads/master'
   end

  def expect_repository_access
    path = File.dirname(__FILE__) + '/../fixtures/'
    Git.expects(:log).with(REVISIONS.first, REVISIONS.last).returns(read_file(path + 'git_log'))
    Git.expects(:mailing_list_address).returns('recipient@test.com')
    REVISIONS.each do |rev|
      Git.expects(:show).with(rev).returns(read_file(path + "git_show_#{rev}"))
    end
  end

end
