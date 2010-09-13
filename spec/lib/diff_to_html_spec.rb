require File.expand_path('../spec_helper.rb', File.dirname(__FILE__))
require 'diff_to_html'

describe DiffToHtml do
  describe :lines_are_sequential? do
    before(:all) do
      @diff_to_html = DiffToHtml.new
    end

    it "should be true if left line numbers are sequential" do
      @diff_to_html.lines_are_sequential?({
        :added => 2,
        :removed => 2
      }, {
        :added => 3,
        :removed => 6
      }).should be_true
    end

    it "should be true if right line numbers are sequential" do
      @diff_to_html.lines_are_sequential?({
        :added => 2,
        :removed => 2
      }, {
        :added => 7,
        :removed => 3
      }).should be_true
    end

    it "should be false unless line numbers are sequential" do
      @diff_to_html.lines_are_sequential?({
        :added => 2,
        :removed => 2
      }, {
        :added => 4,
        :removed => 6
      }).should be_false
    end

    it "should be true if left line numbers are sequential (right are nil)" do
      @diff_to_html.lines_are_sequential?({
        :added => 2,
        :removed => 2
      }, {
        :added => 3,
        :removed => nil
      }).should be_true
    end

    it "should be true if right line numbers are sequential (left are nil)" do
      @diff_to_html.lines_are_sequential?({
        :added => nil,
        :removed => 2
      }, {
        :added => 7,
        :removed => 3
      }).should be_true
    end

    it "should be false unless line numbers are sequential (nils)" do
      @diff_to_html.lines_are_sequential?({
        :added => nil,
        :removed => nil
      }, {
        :added => 4,
        :removed => 6
      }).should be_false
    end
  end
end