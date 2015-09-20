# -*- encoding: utf-8 -*-
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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake',      '~> 10.4', '>= 10.4.2'
  s.add_development_dependency 'rspec',     '~> 3.3',  '>= 3.3.0'
  s.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'

  s.add_development_dependency 'jpi',                    '~> 0.4', '>= 0.4.0'
  s.add_development_dependency 'jenkins-plugin-runtime', '~> 0.2', '>= 0.2.3'
end
