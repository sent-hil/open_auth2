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
      subject.provider.should be_a OpenAuth2::Provider::Default
    end

    it 'accepts a block to set config' do
      subject.client_id.should == :set_in_new
    end
  end

  context '#provider=' do
    let(:facebook_const) do
      OpenAuth2::Provider::Facebook
    end

    before do
      subject.provider = OpenAuth2::Provider::Facebook
    end

    it 'sets provider' do
      subject.provider.should be_a facebook_const
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

    it 'does not set provider if arg is nil' do
      expect do
        subject.provider = nil
      end.to_not change{subject.provider}
    end
  end

  let(:overwrite_response_type) do
    subject.response_type = :overwritten
  end

  context '#reset_provider' do
    it 'resets locally set values' do
      overwrite_response_type
      subject.reset_provider

      subject.response_type.should == 'code'
    end

    let(:set_to_fb_and_reset) do
      subject.provider = OpenAuth2::Provider::Facebook
      subject.reset_provider
    end

    it 'resets provider to default' do
      set_to_fb_and_reset
      subject.provider.should be_a OpenAuth2::Provider::Default
    end

    it 'resets all config to default values' do
      set_to_fb_and_reset
      subject.authorize_url.should == nil
    end
  end
end
