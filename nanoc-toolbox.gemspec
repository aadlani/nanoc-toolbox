# -*- encoding: utf-8 -*-
require File.expand_path("../lib/nanoc/toolbox/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "nanoc-toolbox"
  s.version      = Nanoc::Toolbox::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Anouar ADLANI"]
  s.email        = ["anouar@adlani.com"]
  s.homepage     = "http://aadlani.github.com/nanoc-toolbox/"
  s.summary      = "A collection of helper and filters for nanoc"
  s.description  = "The nanoc-toolbox is a collection of filters and helpers for the static site generator tool nanoc"
  s.rdoc_options = ["--main", "README.rdoc"]

  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "nanoc",    "~> 3.7"
  s.add_dependency "nokogiri", "~> 1.6"
  s.add_dependency "jsmin",    "~> 1.0"
  
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rspec",   "~> 2.13"
  s.add_development_dependency "rake",    "~> 10.3"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
