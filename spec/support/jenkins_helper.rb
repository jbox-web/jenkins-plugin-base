module JenkinsHelper

  def build_plugin(klass)
    peer = double(name: 'org.jenkinsci.ruby.RubyPlugin')
    allow(peer).to receive(:addExtension)
    plugin = Jenkins::Plugin.new peer
    allow(plugin).to receive(:export) { |obj| obj }
    plugin.register_extension klass
    plugin
  end


  def new_file(path)
    OpenStruct.new(file: file_object(path))
  end


  def file_object(path)
    OpenStruct.new(exists?: true, canonicalPath: path)
  end


  def build_descriptor_with_config_file(config_file = fixture_path('jenkins_test.xml'))
    plugin = build_plugin(FooModel)
    expect_any_instance_of(FooModelDescriptor).to receive(:configFile).at_least(:once).and_return(new_file(config_file))
    FooModelDescriptor.new(FooModel, plugin, Java.hudson.model.Descriptor.java_class)
  end


  def fixture_path(fixture)
    Pathname(__FILE__).dirname.join('..', 'fixtures', fixture).to_s
  end

end
