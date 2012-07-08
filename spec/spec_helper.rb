require 'simplecov'
SimpleCov.start

require "rspec/core"
require 'rspec/mocks'
require "nanoc/toolbox"
require "nanoc3"

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end

RSpec.configure do |config|
  config.mock_with :rspec
end
