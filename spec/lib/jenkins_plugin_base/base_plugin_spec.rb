require 'spec_helper'

describe JenkinsPluginBase::BasePlugin do

  include JenkinsHelper

  class FooModelDescriptor < Jenkins::Model::DefaultDescriptor
    include ::JenkinsPluginBase::BaseConfig
    set_plugin_name 'jenkins-plugin-test'
    set_plugin_settings({
      foo: 'default_value',
      bar: 'default_value'
    })
  end


  class FooModel < Jenkins::Model::RootAction
    include ::JenkinsPluginBase::BasePlugin
  end


  describe '.get_setting_value_for' do
    context 'when settings exist' do
      it 'should return plugin settings value' do
        descriptor = build_descriptor_with_config_file
        allow(FooModel).to receive(:plugin_descriptor).and_return(descriptor)
        expect(FooModel.get_setting_value_for(:foo)).to eq 'bar'
      end
    end

    context 'when settings doesnt exist' do
      it 'should raise an exception' do
        descriptor = build_descriptor_with_config_file
        allow(FooModel).to receive(:plugin_descriptor).and_return(descriptor)
        expect {
          FooModel.get_setting_value_for(:far)
        }.to raise_exception(JenkinsPluginBase::BasePlugin::UnknownAttributeError, 'Unknown attribute: far')
      end
    end
  end

end
