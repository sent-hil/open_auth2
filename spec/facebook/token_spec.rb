require 'open_auth2'
require 'spec_helper'

describe 'Facebook Token' do
  let(:config) do
    facebook_config
  end

  subject do
    OpenAuth2::Token.new(config)
  end

  context '#build_code_url' do
    it 'returns url' do
      url = "https://www.facebook.com/dialog/oauth?response_type=code&client_id=369754433115833&redirect_uri=http%3A%2F%2Flocalhost%3A9393%2F&scope=offline_access%2Cpublish_stream"

      subject.build_code_url.should == url
    end

    it 'accepts params' do
      url = "https://www.facebook.com/dialog/oauth?response_type=code&client_id=369754433115833&redirect_uri=http%3A%2F%2Flocalhost%3A9393%2F&scope=publish_stream"

      subject.build_code_url(:scope => 'publish_stream').should == url
    end
  end

  context '#get' do
    let(:get_token) do
      VCR.use_cassette('facebook/access_token') do
        subject.get
      end
    end

    let(:time) do
      Time.local(2012, 12, 21)
    end

    before do
      Timecop.freeze(time) do
        get_token
      end
    end

    it 'requests OAuth server for access token' do
      get_token.status.should == 200
    end

    it 'sets #access_token' do
      subject.access_token.should == Creds['Facebook']['AccessToken']
    end

    it 'sets #refresh_token' do
      subject.refresh_token.should == Creds['Facebook']['AccessToken']
    end

    it 'sets #token_arrived_at' do
      subject.token_arrived_at.should == time
    end

    it 'sets #token_expires_at' do
      subject.token_expires_at.to_s.should == (time+5184000).to_s
    end

    it 'returns false for #token_expired?' do
      subject.token_expired?.should == false
    end
  end

  context '#refresh' do
    let(:refresh_token) do
      config.configure do |c|
        c.refresh_token = Creds['Facebook']['AccessToken']
      end

      VCR.use_cassette('facebook/refresh_token') do
        subject.refresh
      end
    end

    it 'requests OAuth server to refresh access token' do
      refresh_token.status.should == 200
    end

    it 'sets new #access_token' do
      refresh_token
      subject.access_token.should == Creds['Facebook']['AccessToken']
    end
  end
end
