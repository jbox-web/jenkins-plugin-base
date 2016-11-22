require 'java'
require 'jenkins_peace'
require 'jenkins/plugin/tools/loadpath'
require 'jenkins/plugin/tools/resolver'
require 'jenkins/plugin/tools/manifest'
require 'zip'

module Jenkins
  def self.rspec_ewwww_gross_hack?
    true
  end
end

module JenkinsPluginBase
  class Loader

    Zip.on_exists_proc = true

    attr_reader :tmp_dir
    attr_reader :version
    attr_reader :overwrite
    attr_reader :url

    attr_reader :war_file


    def initialize(tmp_dir = nil)
      @tmp_dir   = tmp_dir || 'work/plugins'
      @version   = ENV['JENKINS_VERSION'] || 'latest'
      @overwrite = ENV['JENKINS_OVERWRITE_VERSION'] || 'false'
      @url       = ENV['JENKINS_URL']

      @overwrite = @overwrite == 'false' ? false : true
    end


    def load!
      preload
      load
    end


    def preload
      @war_file = Jenkins::Peace.install(version, overwrite, url)
      resolve_dependencies
      extract_dependencies
    end


    def load
      Dir[war_file.klass_path].each { |file| require file }
      require 'jenkins/plugin/runtime'
    end


    private


      def spec
        OpenStruct.new(version: '1.0.0', name: 'foo', display_name: 'Foo', dependencies: { 'ruby-runtime' => '0.12' })
      end


      def ruby_runtime_path
        File.join(tmp_dir, 'ruby-runtime.hpi')
      end


      def ruby_runtime_klass_path
        Pathname(__FILE__).dirname.join('../../src/classes.jar').to_s
      end


      def jenkins_plugins_path(*args)
        File.join(war_file.plugins_path, *args)
      end


      def resolve_dependencies
        FileUtils.mkdir_p(tmp_dir)
        loadpath = Jenkins::Plugin::Tools::Loadpath.new
        manifest = Jenkins::Plugin::Tools::Manifest.new(spec)
        resolver = Jenkins::Plugin::Tools::Resolver.new(spec, tmp_dir)
        resolver.resolve!

        # generate the plugin manifest
        File.open("#{tmp_dir}/#{spec.name}.hpl", 'w+') do |f|
          manifest.write_hpl(f, loadpath)
        end
      end


      def extract_dependencies
        FileUtils.mkdir_p(jenkins_plugins_path)
        FileUtils.cp(ruby_runtime_path, jenkins_plugins_path)
        extract_zip(ruby_runtime_path, jenkins_plugins_path('ruby-runtime'))
        FileUtils.cp(ruby_runtime_klass_path, jenkins_plugins_path('ruby-runtime', 'WEB-INF', 'lib'))
      end


      def extract_zip(source, destination)
        Zip::File.open(source) do |zip_file|
          zip_file.each { |entry| entry.extract("#{destination}/#{entry.name}") }
        end
      end

  end
end
