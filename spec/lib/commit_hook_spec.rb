require File.expand_path('../spec_helper.rb', File.dirname(__FILE__))
require 'commit_hook'

describe CommitHook do

  it "should ignore merge" do
    # 4 commits, one email for each of them, without merge
    run_with_config('spec/fixtures/git-notifier-ignore-merge.yml', 4)
  end

  it "should hook with merge" do
    # 5 commits, one email for each of them, with merge mail
    run_with_config('spec/fixtures/git-notifier-with-merge.yml', 5)
  end

  it "should hook group email by push" do
    # 1 commit for the push, all commits in the one message
    run_with_config('spec/fixtures/git-notifier-group-email-by-push.yml', 1)
  end

  def run_with_config(config, times)
    expect_repository_access

    emailer = mock!.send.times(times).subject
    mock(Emailer).new(anything, anything) { emailer }.times(times)

    mock(CommitHook).info(/Sending mail/)

    CommitHook.run config, REVISIONS.first, REVISIONS.last, 'refs/heads/master'
  end

  def test_commit_from
    # 1 commit with a from: adress
    expect_repository_access
    emailer = mock!.send.subject
    mock(Emailer).new(anything, hash_including(:from_address => "max@example.com")) { emailer }
    
    CommitHook.run 'spec/fixtures/git-notifier-group-email-by-push.yml', REVISIONS.first, REVISIONS.last, 'refs/heads/master'
   end

  def expect_repository_access
    path = File.dirname(__FILE__) + '/../fixtures/'
    mock(Git).log(REVISIONS.first, REVISIONS.last) { IO.read(path + 'git_log') }
    mock(Git).mailing_list_address { 'recipient@test.com' }
    REVISIONS.each do |rev|
      mock(Git).show(rev) { IO.read(path + "git_show_#{rev}") }
    end
  end

  describe :debug? do
    it "should be false unless debug section exists" do
      mock(CommitHook).config { {} }.any_times
      CommitHook.should_not be_debug
    end

		it "should be false unless debug/enabled" do
      mock(CommitHook).config { { "debug" => { "enabled" => false } } }.any_times
      CommitHook.should_not be_debug
    end

		it "should be true if debug/enabled" do
      mock(CommitHook).config { { "debug" => { "enabled" => true } } }.any_times
      CommitHook.should be_debug
    end
	end

	describe :log_directory do
		it "should be nil unless debug?" do
			mock(CommitHook).debug? { false }
			CommitHook.log_directory.should be_nil
		end

		it "should be custom if debug and custom directory specified" do
			expected = Faker::Lorem.sentence
      mock(CommitHook).config { { "debug" => { "enabled" => true, "log_directory" => expected } } }.any_times
			CommitHook.log_directory.should == expected
		end

		it "should be system temp directory if debug and custom directory not specified" do
      mock(CommitHook).config { { "debug" => { "enabled" => true } } }.any_times
			CommitHook.log_directory.should == Dir.tmpdir
		end
	end


end
