module JenkinsPluginBase
  module BasePlugin

    class UnknownAttributeError < StandardError; end

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

      #
      # This is the (not so) magic method to retrieve Global configuration settings.
      #
      def get_setting_value_for(setting)
        if plugin_descriptor.respond_to?(setting)
          plugin_descriptor.send(setting)
        else
          raise UnknownAttributeError.new("Unknown attribute: #{setting}")
        end
      end


      def plugin_descriptor
        Jenkins::Plugin.instance.descriptors[self]
      end

    end

  end
end
