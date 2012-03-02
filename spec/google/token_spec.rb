require 'open_auth2'
require 'spec_helper'

describe 'Google Token' do
  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider       = :google
      c.client_id      = Creds::Google::ClientId
      c.client_secret  = Creds::Google::ClientSecret
      c.code           = Creds::Google::Code
      c.redirect_uri   = 'http://localhost:9393/google/callback'
      c.scope          = ['https://www.googleapis.com/auth/calendar']
    end
  end

  subject do
    OpenAuth2::Token.new(config)
  end

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
      subject.access_token.should == Creds::Google::AccessToken
    end

    it 'sets #refresh_token' do
      subject.refresh_token.should == Creds::Google::RefreshToken
    end

    it 'sets #token_arrived_at' do
      subject.token_arrived_at.should == time
    end

    it 'returns false for #token_expired?' do
      subject.token_expired?.should == true
    end
  end
end
