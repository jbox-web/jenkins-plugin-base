# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

require 'jenkins_plugin_base/loader'
JenkinsPluginBase::Loader.new.load!

# Start Simplecov
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter])

  add_filter '/spec/'
  add_filter '/lib/core_ext'
  add_filter '/lib/active_support'
end

# Load helper modules
Dir[Pathname(__FILE__).dirname.join('support', '**', '*.rb')].each { |f| require f }

# Configure RSpec
RSpec.configure do |config|
  # clean out jruby-related stacktrace lines that do not add meaningful information
  config.backtrace_exclusion_patterns << /sun\.reflect/
  config.backtrace_exclusion_patterns << /org\.jruby/

  config.color = true
  config.fail_fast = false

  # config.order = :random
  # Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.raise_errors_for_deprecations!
end

require 'jenkins_plugin_base'
