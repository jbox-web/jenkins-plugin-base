module JenkinsPluginBase
  autoload :BaseConfig, 'jenkins_plugin_base/base_config'
  autoload :BasePlugin, 'jenkins_plugin_base/base_plugin'

  require 'active_support/inflector/methods'

  require 'core_ext/string/inflections'
  require 'core_ext/string/quote'

  require 'patches/build'
end
