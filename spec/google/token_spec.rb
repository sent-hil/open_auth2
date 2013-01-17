require 'spec_helper'

describe 'Google Token' do
  subject {OpenAuth2::Token.new(google_config)}

  context '#build_code_url' do
    it 'returns url' do
      url = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=77848792642.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A9393%2Fgoogle%2Fcallback&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar&approval_prompt=force&access_type=offline"

      params = {:approval_prompt => 'force', :access_type => 'offline'}
      subject.build_code_url(params).should == url
    end
  end

  context '#get' do
    let(:get_token) do
      VCR.use_cassette('goog/access_token') do
        subject.get
      end
    end

    let(:time) {Time.local(2012, 12, 21)}

    before do
      Timecop.freeze(time) do
        get_token
      end
    end

    it 'requests OAuth server for access token' do
      get_token.status.should == 200
    end

    it 'sets #access_token' do
      subject.access_token.should == Creds['Google']['AccessToken']
    end

    it 'sets #refresh_token' do
      subject.refresh_token.should == Creds['Google']['RefreshToken']
    end

    it 'sets #token_arrived_at' do
      subject.token_arrived_at.should == time
    end

    it 'returns true for #token_expired?' do
      subject.token_expired?.should == true
    end
  end

  context '#refresh' do
    let(:refresh_token) do
      google_config.refresh_token = Creds['Google']['RefreshToken']

      VCR.use_cassette('goog/refresh_token') do
        subject.refresh
      end
    end

    it 'requests OAuth server to refresh access token' do
      refresh_token.status.should == 200
    end

    it 'sets new #access_token' do
      refresh_token
      subject.access_token.should == Creds['Google']['NewAccessToken']
    end
  end
end
