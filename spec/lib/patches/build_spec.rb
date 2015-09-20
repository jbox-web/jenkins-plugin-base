require 'spec_helper'

describe Jenkins::Model::Build do

  include Jenkins::Model

  before :each do
    @native = double(Java.hudson.model.AbstractBuild)
    allow(@native).to receive(:buildEnvironments).and_return(java.util.ArrayList.new)
    @build = Jenkins::Model::Build.new(@native)
  end

  describe '#getNumber' do
    it 'should return the build number' do
      allow(@native).to receive(:getNumber).and_return('12')
      expect(@build.getNumber).to eq('12')
      expect(@build.number).to eq('12')
    end
  end

end
