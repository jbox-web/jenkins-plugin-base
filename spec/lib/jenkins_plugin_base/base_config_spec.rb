require 'spec_helper'
require 'fileutils'

describe JenkinsPluginBase::BaseConfig do

  include JenkinsHelper

  class FooModelDescriptor < Jenkins::Model::DefaultDescriptor
    include ::JenkinsPluginBase::BaseConfig
  end


  class FooModel < Jenkins::Model::RootAction
    include ::JenkinsPluginBase::BasePlugin
  end


  def xml_with_values
    %Q(<?xml version='1.0' encoding='UTF-8'?>
<hudson.model.Descriptor plugin="plugin-foo">
  <foo>bar</foo>
  <bar>foo</bar>
  <boo></boo>
</hudson.model.Descriptor>\n)
  end


  def xml_without_values
    %Q(<?xml version='1.0' encoding='UTF-8'?>
<hudson.model.Descriptor plugin="plugin-foo">
  <foo></foo>
  <bar></bar>
  <boo></boo>
</hudson.model.Descriptor>\n)
  end


  describe 'class methods' do
    describe '.set_plugin_name' do
      it 'should set plugin name' do
        FooModelDescriptor.set_plugin_name('plugin-foo')
        expect(FooModelDescriptor.plugin_name).to eq 'plugin-foo'
      end
    end


    describe '.set_plugin_settings' do
      it 'should set plugin settings' do
        FooModelDescriptor.set_plugin_settings({ foo: :bar, bar: :foo, boo: :far })
        expect(FooModelDescriptor.plugin_settings).to eq({ foo: :bar, bar: :foo, boo: :far })
      end
    end
  end


  describe 'instance methods' do
    describe '#initialize' do
      it 'should load value from XML' do
        descriptor = build_descriptor_with_config_file
        expect(descriptor.foo).to eq 'bar'
        expect(descriptor.bar).to eq 'foo'
      end
    end


    describe '#configure' do
      it 'should update object attributes' do
        descriptor = build_descriptor_with_config_file
        form = double(Java.hudson.XmlFile)
        allow(form).to receive(:[]).with('foo').and_return('new_value')
        allow(form).to receive(:[]).with('bar').and_return('new_value')
        allow(form).to receive(:[]).with('boo').and_return(nil)
        allow(descriptor).to receive(:save)
        descriptor.configure(nil, form)
        expect(descriptor.foo).to eq 'new_value'
        expect(descriptor.bar).to eq 'new_value'
      end
    end


    describe '#to_xml' do
      it 'should generate XML content' do
        descriptor = build_descriptor_with_config_file
        expect(descriptor.to_xml).to eq xml_with_values
      end
    end


    describe '#save' do
      it 'should save XML content' do
        config_file = fixture_path('jenkins_test_result.xml')
        FileUtils.touch(config_file)
        descriptor = build_descriptor_with_config_file(config_file)
        allow(SaveableListener).to receive(:fireOnChange)
        expect(descriptor).to receive(:trigger_listener).at_least(:once)
        descriptor.save
        expect(File.read(config_file)).to eq xml_without_values
      end
    end

  end

end
