require 'open_auth2'
require 'spec_helper'

describe OpenAuth2::Config do
  subject { described_class.new }

  it 'overwrites default values' do
    overwrite_response_type
    subject.response_type.should == :overwritten
  end

  context '#initialize' do
    subject do
      described_class.new do |c|
        c.client_id = :set_in_new
      end
    end

    it 'sets default as provider' do
      subject.provider.should == :default
    end

    it 'accepts a block to set config' do
      subject.client_id.should == :set_in_new
    end
  end

  context '#configure' do
    it 'accepts a block to set/overwrite config' do
      subject.configure do |c|
        c.client_id = :set_in_configure
      end

      subject.client_id.should == :set_in_configure
    end
  end

  context '#provider=' do
    before do
      subject.provider = :facebook
    end

    it 'sets provider' do
      subject.provider.should == :facebook
    end

    it 'sets provider_string' do
      subject.provider_string.should == 'facebook'
    end

    let(:facebook_const) do
      OpenAuth2::Provider::Facebook
    end

    it 'sets provider_const' do
      subject.provider_const.should == facebook_const
    end

    it 'copies over options from provider' do
      subject.authorize_url.should == 'https://graph.facebook.com'
    end

    it 'keeps non-overlapping default options' do
      subject.response_type.should == 'code'
    end

    it 'overwrites overlapping default options' do
      subject.refresh_token_name.should == 'fb_exchange_token'
    end

    it 'raises UnknownProvider if arg is not in list of providers' do
      expect do
        subject.provider = :unknown
      end.to raise_error(OpenAuth2::UnknownProvider)
    end

    it 'provides list of known providers with UnknownProvider' do
      # mimicking beh. of users including their own provider
      module OpenAuth2::Provider module UserDefined end end

      expect do
        subject.provider = :unknown
      end.to raise_error(OpenAuth2::UnknownProvider)
    end

    #it 'does not set provider if arg is nil' do
      #expect do
        #subject.provider = 'facebook'
      #end.to_not change(subject.provider)
    #end

    it 'does not set provider if arg is nil' do
      subject.provider.should == :facebook
      subject.provider = nil
      subject.provider.should == :facebook
    end
  end

  let(:overwrite_response_type) do
    subject.configure do |c|
      c.response_type = :overwritten
    end
  end

  context '#reset_provider' do
    it 'resets locally set values' do
      overwrite_response_type
      subject.reset_provider

      subject.response_type.should == 'code'
    end

    let(:set_to_fb_and_reset) do
      subject.provider = :facebook
      subject.reset_provider
    end

    it 'resets provider to default' do
      set_to_fb_and_reset
      subject.provider.should == :default
    end

    it 'resets all config to default values' do
      set_to_fb_and_reset
      subject.authorize_url.should == nil
    end
  end
end
