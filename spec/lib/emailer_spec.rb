require File.expand_path('../spec_helper.rb', File.dirname(__FILE__))
require 'emailer'

describe Emailer do

  describe :new do
    it "should assign config if given" do
      Emailer.new({:a => :b}, {}).config[:a].should == :b
    end
  end
end

