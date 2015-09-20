require 'rubygems'
require 'simplecov'
require 'rspec'

version   = ENV['JENKINS_VERSION'] || 'latest'
overwrite = ENV['JENKINS_OVERWRITE_VERSION'] || 'false'
url       = ENV['JENKINS_URL']

overwrite = overwrite == 'false' ? false : true

require 'jenkins_loader'
JenkinsLoader.new.load!(version, overwrite, url)

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]

## Start Simplecov
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/lib/core_ext'
  add_filter '/lib/active_support'
end

Dir[Pathname(__FILE__).dirname.join('support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # clean out jruby-related stacktrace lines that do not add meaningful information
  config.backtrace_exclusion_patterns << /sun\.reflect/
  config.backtrace_exclusion_patterns << /org\.jruby/

  config.color = true
  config.fail_fast = false
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'jenkins_plugin_base'
