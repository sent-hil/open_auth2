require 'open_auth2'
require 'spec_helper'

describe OpenAuth2::Client do
  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider     = :facebook
      c.access_token = :access_token
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

    it 'sets @faraday_url' do
      subject.faraday_url.should == 'https://graph.facebook.com'
    end
  end

  context '#configure' do
    it 'accepts a block to set/overwrite config' do
      subject.configure do |c|
        c.access_token  = :access_token
        c.refresh_token = :refresh_token
      end

      subject.access_token.should  == :access_token
      subject.refresh_token.should == :refresh_token
    end

    it 'raises NoConfigObject' do
      expect do
        subject = described_class.new(config)
        subject.configure {|c| c.config = nil }
      end.to raise_error(OpenAuth2::NoConfigObject)
    end

    it 'raises UnknownConfigObject' do
      expect do
        subject = described_class.new(config)
        subject.configure {|c| c.config = 'string' }
      end.to raise_error(OpenAuth2::UnknownConfigObject)
    end
  end

  context '#token' do
    it 'returns OpenAuth2::Token object' do
      subject.token.should be_an(OpenAuth2::Token)
    end
  end

  context '#build_code_url' do
    it 'delegates to OpenAuth2::Token' do
      OpenAuth2::Token.any_instance.should_receive(:build_code_url)
      subject.build_code_url
    end
  end

  subject { described_class.new(config) }

  context OpenAuth2::DelegateToConfig do
    it 'delegates Options getter methods' do
      subject.authorize_url.should == 'https://graph.facebook.com'
    end

    it 'delegates Options setter methods' do
      url = 'http://facebook.com'
      subject.authorize_url = url

      subject.authorize_url.should == url
    end

    it 'overwritten Options stays that way' do
      config.access_token.should == :access_token
    end
  end

  context OpenAuth2::Connection do
    it 'returns Faraday::Connection object' do
      subject.connection.should be_a(Faraday::Connection)
    end

    it 'yields Faraday::Connection object' do
      subject.connection do |f|
        f.response :logger
      end
    end
  end
end
