require 'open_auth2'
require 'spec_helper'

describe OpenAuth2::Client do
  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider     = :facebook
      c.access_token = :access_token
    end
  end

  subject do
    described_class.new(config)
  end

  context '#initialize' do
    it 'accepts config as argument' do
      subject.config.should == config
    end

    it 'accepts config via block' do
      rspec = self
      subject = described_class.new do
        self.config = rspec.config
      end

      subject.config.should == config
    end

    it 'sets @faraday_url' do
      subject.faraday_url.should == 'https://graph.facebook.com'
    end
  end

  context '#configure' do
    it 'accepts a block to set/overwrite config' do
      subject.configure do
        self.access_token  = :access_token
        self.refresh_token = :refresh_token
      end

      subject.access_token.should  == :access_token
      subject.refresh_token.should == :refresh_token
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
