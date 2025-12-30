# frozen_string_literal: true

$:.push File.expand_path('../lib', __FILE__)
require 'jenkins_plugin_base/version'

Gem::Specification.new do |s|
  s.name        = 'jenkins-plugin-base'
  s.version     = JenkinsPluginBase::VERSION
  s.platform    = 'java'
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nrodriguez@jbox-web.com']
  s.homepage    = 'https://github.com/jbox-web/jenkins-plugin-base'
  s.summary     = %q{A lib to write Jenkins plugins in Ruby.}
  s.description = %q{This lib provides boilerplate code to write Jenkins plugins in Ruby}
  s.license     = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'

  s.add_development_dependency 'jpi',                    '~> 0.4', '>= 0.4.0'
  s.add_development_dependency 'jenkins-plugin-runtime', '~> 0.2', '>= 0.2.3'
end
