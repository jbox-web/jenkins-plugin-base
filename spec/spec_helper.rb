require 'rubygems'
require 'simplecov'
require 'rspec'
require 'codeclimate-test-reporter'

require 'jenkins_plugin_base/loader'
JenkinsPluginBase::Loader.new.load!

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  # CodeClimate::TestReporter::Formatter
])

## Start Simplecov
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/lib/core_ext'
  add_filter '/lib/active_support'
end

## Load helper modules
Dir[Pathname(__FILE__).dirname.join('support', '**', '*.rb')].each { |f| require f }

## Configure RSpec
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
