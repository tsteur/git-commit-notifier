require File.expand_path('../../spec_helper', __FILE__)

require 'git_commit_notifier'

include GitCommitNotifier

describe Emailer do
  describe :new do
    it "should assign config if given" do
      Emailer.new({:a => :b}).config[:a].should == :b
    end

    it "should use empty hash unless config given" do
      cfg = Emailer.new(false).config
      cfg.should be_kind_of(Hash)
      cfg.should be_empty
    end

    it "should assign parameters from options" do
      options = {}
      Emailer::PARAMETERS.each do |name|
        options[name.to_sym] = Faker::Lorem.sentence
      end
      emailer = Emailer.new({}, options)
      options.each_pair do |key, value|
        emailer.instance_variable_get("@#{key}").should == value
      end
    end
  end

  describe :stylesheet_string do
    it "should return default stylesheet if custom is not provided" do
      emailer = Emailer.new({})
      mock(IO).read(Emailer::DEFAULT_STYLESHEET_PATH) { 'ok' }
      emailer.stylesheet_string.should == 'ok'
    end

    it "should return custom stylesheet if custom is provided" do
      emailer = Emailer.new({'stylesheet' => '/path/to/custom/stylesheet'})
      mock(IO).read('/path/to/custom/stylesheet') { 'ok' }
      dont_allow(IO).read(Emailer::DEFAULT_STYLESHEET_PATH)
      emailer.stylesheet_string.should == 'ok'
    end
  end

  describe :mail_html_message do
    it "should form inline html" do
      options = {}
      Emailer::PARAMETERS.each do |name|
        options[name.to_sym] = Faker::Lorem.sentence
      end
      emailer = Emailer.new({}, options)
      emailer.mail_html_message.should match(/html/)
    end
  end

  describe :template do
    before(:each) do
      Emailer.reset_template
      mock(IO).read(Emailer::TEMPLATE) { 'erb' }
    end

    it "should respond to result" do
      Emailer.template.should respond_to(:result)
    end

    it "should return Erubis template if Erubis installed" do
      mock(Emailer).require('erubis')
      dont_allow(Emailer).require('erb')
      unless defined?(Erubis)
        module Erubis
          class Eruby
            def initialize(erb)
            end
          end
        end
      end
      mock.proxy(Erubis::Eruby).new('erb')
      Emailer.template.should be_kind_of(Erubis::Eruby)
    end

    it "should return ERB template unless Erubis installed" do
      require 'erb'
      mock(Emailer).require('erubis') { raise LoadError.new('erubis') }
      mock(Emailer).require('erb')
      mock.proxy(ERB).new('erb')
      
      Emailer.template.should be_kind_of(ERB)
    end
  end
end
