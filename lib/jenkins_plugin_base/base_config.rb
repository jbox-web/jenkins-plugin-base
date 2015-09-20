include Java

java_import Java.hudson.BulkChange
java_import Java.hudson.model.listeners.SaveableListener

# java_import Java.java.util.logging.Logger
# java_import Java.java.util.logging.Level

module JenkinsPluginBase
  module BaseConfig

    class << self
      def included(receiver)
        receiver.send(:extend, ClassMethods)
        receiver.send(:include, InstanceMethods)
      end
    end


    module ClassMethods


      def set_plugin_name(name)
        @plugin_name = name
      end


      #
      # Auto-create accessors for plugin settings so they can be
      # accessed from outside of this class.
      #
      def set_plugin_settings(settings = {})
        @plugin_settings = settings
        @plugin_settings.keys.each do |key|
          attr_accessor key
        end
      end


      def plugin_name
        @plugin_name
      end


      def plugin_settings
        @plugin_settings
      end

    end


    module InstanceMethods

      #
      # Override the default constructor to load our plugin settings.
      # (it's not done automatically).
      # Becareful! This method is called only once during Jenkins session.
      #
      def initialize(impl, plugin, java_class)
        super
        load
      end


      #
      # Load our plugin settings from XML file.
      # @see hudson.model.Descriptor#load()
      #
      def load
        return unless configFile.file.exists?
        load_values_from_xml(File.read(configFile.file.canonicalPath))
      end


      #
      # Save our plugin settings to XML file.
      # @see hudson.model.Descriptor#save()
      #
      def save
        return if BulkChange.contains(self)

        begin
          File.open(configFile.file.canonicalPath, 'wb') { |f| f.write(to_xml) }
        rescue => e
          # logger.severe "Failed to save #{configFile}: #{e.message}"
        else
          trigger_listener
        end
      end


      #
      # Get params from the posted form.
      # @see hudson.model.Descriptor#configure()
      #
      def configure(req, form)
        set_values_from_form(form)
        save
        true
      end


      #
      # Generate XML content to save our settings.
      #
      def to_xml
        xml_header + xml_content + xml_footer
      end


      private


        #
        # Get a logger instance for our class.
        # Becareful! Only these logger methods exist :
        #  * info
        #  * warning
        #  * severe
        #
        def logger
          @logger ||= Logger.getLogger(self.class.name)
        end


        #
        # Load settings from XML file and set instance variables.
        #
        def load_values_from_xml(xml)
          self.class.plugin_settings.keys.each do |setting|
            value = xml.scan(/<#{setting}>(.*)<\/#{setting}>/).flatten.first
            instance_variable_set("@#{setting}", value)
          end
        end


        #
        # Load settings from posted form and set instance variables.
        # If values are empty, take the default one from plugin settings declaration.
        #
        def set_values_from_form(form)
          self.class.plugin_settings.each do |setting, default_value|
            value = fix_empty(form[setting.to_s]) || default_value
            instance_variable_set("@#{setting}", value)
          end
        end


        def xml_header
          "<?xml version='1.0' encoding='UTF-8'?>\n" +
          "<#{id} plugin=\"#{self.class.plugin_name}\">\n"
        end


        def xml_content
          str = ''
          self.class.plugin_settings.keys.each do |setting|
            str << "  <#{setting}>#{instance_variable_get("@#{setting}")}</#{setting}>\n"
          end
          str
        end


        def xml_footer
          "</#{id}>\n"
        end


        def fix_empty(s)
          s.strip.empty? ? nil : s
        rescue
          nil
        end


        def trigger_listener
          # logger.info "#{self.class.name} : configuration saved!"
          SaveableListener.fireOnChange(self, configFile)
        end

    end

  end
end
