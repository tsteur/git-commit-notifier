require 'rubygems'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |conf|
  conf.mock_with :rr
end

