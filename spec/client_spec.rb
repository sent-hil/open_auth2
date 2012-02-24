require 'open_auth2'
require 'spec_helper'

describe OpenAuth2::Client do
  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider = :facebook
    end
  end

  context '#initialize' do
    it 'accepts config as argument' do
      subject = described_class.new(config)
      subject.config.should == config
    end

    it 'accepts config via block' do
      subject = described_class.new do |c|
        c.config = config
      end
    end

    it 'raises NoConfigObject' do
      expect do
        subject = described_class.new
      end.to raise_error(OpenAuth2::NoConfigObject)
    end

    it 'raises UnknownConfigObject' do
      expect do
        subject = described_class.new('string')
      end.to raise_error(OpenAuth2::UnknownConfigObject)
    end
  end

  context OpenAuth2::DelegateToConfig do
    subject do
      described_class.new do |c|
        c.config = config
      end
    end

    it 'delegates Options getter methods' do
      subject.authorize_url.should == 'https://graph.facebook.com'
    end

    it 'delegates Options setter methods' do
      url = 'http://facebook.com'
      subject.authorize_url = url

      subject.authorize_url.should == url
    end
  end
end
