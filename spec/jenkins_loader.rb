require 'java'
require 'jenkins_peace'
require 'jenkins/plugin/tools/loadpath'
require 'jenkins/plugin/tools/resolver'
require 'jenkins/plugin/tools/manifest'
require 'zip'

class JenkinsLoader

  Zip.on_exists_proc = true

  attr_reader :tmp_dir
  attr_reader :war_file


  def initialize(tmp_dir = nil)
    @tmp_dir = tmp_dir || 'work/plugins'
  end


  def load!(version, overwrite = false, url = nil)
    preload(version, overwrite, url)
    load
  end


  def preload(version, overwrite = false, url = nil)
    @war_file = Jenkins::Peace.install(version, overwrite, url)
    resolve_dependencies
    extract_dependencies
  end


  def load
    Dir[war_file.klass_path].each do |path|
      $CLASSPATH << path
    end

    $:.unshift Pathname(__FILE__).dirname.join('../lib').to_s

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
      Pathname(__FILE__).dirname.join('../src/classes.jar').to_s
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
