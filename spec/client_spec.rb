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
    it 'accepts config as an argument' do
      subject.config.should == config
    end

    it 'accepts config via block' do
      subject = described_class.new do |c|
        c.config = config
      end

      subject.config.should == config
    end

    it 'sets endpoint to make requests' do
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
    it 'returns Faraday object' do
      subject.connection.should be_a(Faraday::Connection)
    end

    it 'allows adding custom middleware to Faraday' do
      subject.connection do
        response :logger
      end

      subject.connection.builder.handlers.should
        include(Faraday::Response::Logger)
    end
  end

  context 'no config' do
    subject { OpenAuth2::Client.new }

    it 'defaults to OpenAuth2::Config' do
      subject = described_class.new
      subject.config.should be_a(OpenAuth2::Config)
    end

    it 'makes public request' do
      VCR.use_cassette('facebook/cocacola') do
        url = 'https://graph.facebook.com/cocacola'
        request = subject.get(:path => url)
        request.status.should == 200
      end
    end

    it 'makes private request' do
      VCR.use_cassette('facebook/me') do
        at = "?access_token=#{Creds['Facebook']['AccessToken']}"
        path = "https://graph.facebook.com/me/likes"
        url = path + at
        request = subject.get(:path => url)
        request.status.should == 200
      end
    end
  end
end
