module JenkinsPluginBase
  module BasePlugin

    class << self
      def included(receiver)
        receiver.send(:extend, ClassMethods)
        receiver.class_eval do

          # Basic Jenkins includes
          include Jenkins::Model
          include Jenkins::Model::DescribableNative

          # Declare a Descriptor to handle plugin configuration
          describe_as Java.hudson.model.Descriptor, :with => "#{receiver.name}Descriptor".constantize
        end
      end
    end


    module ClassMethods

      def set_plugin_name(name)
        @plugin_name = name
      end


      def set_plugin_settings(settings = {})
        @plugin_settings = settings
      end


      def plugin_name
        @plugin_name
      end


      def plugin_settings
        @plugin_settings
      end


      #
      # This is the (not so) magic method to retrieve Global configuration settings.
      #
      def get_setting_value_for(setting)
        descriptor = Jenkins::Plugin.instance.descriptors[self]
        if descriptor.respond_to?(setting)
          descriptor.send(setting)
        else
          raise NoMethodError
        end
      end

    end

  end
end
