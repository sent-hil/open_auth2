require 'open_auth2'
require 'spec_helper'

describe OpenAuth2::PluginDsl do
  let(:provider) do
    rspec = self
    klass = Class.new do
      extend rspec.described_class

      options :response_type => 'whatever'

      before_client_post do |number|
        number
      end
    end

    klass
  end

  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider = provider
    end
  end

  let(:provider_inst) {provider.new(config)}

  before(:all) {provider}

  it 'saves classes which extended it' do
    described_class.providers.include?(provider).should == true
  end

  it 'sets provider specific options' do
    config.response_type.should == 'whatever'
  end

  it 'stores provider specific callbacks' do
    provider_inst.before_client_post.call(1).should == 1
  end
end
