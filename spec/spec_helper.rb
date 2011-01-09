require "rspec/core"
require 'rspec/mocks'
require "nanoc/toolbox"

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end

RSpec.configure do |config|
  config.mock_with :rspec
end