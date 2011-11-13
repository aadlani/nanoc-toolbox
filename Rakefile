require 'bundler'
require 'rubygems'
require 'rspec/core/rake_task'
require "rake"

Bundler::GemHelper.install_tasks
 
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/**/*_spec.rb"
end

task :default => :spec