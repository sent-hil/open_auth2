require 'open_auth2'
require 'spec_helper'

describe 'Facebook Client' do
  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider       = :facebook
      c.client_id      = Creds::Facebook::ClientId
      c.client_secret  = Creds::Facebook::ClientSecret
      c.code           = Creds::Facebook::Code
      c.redirect_uri   = 'http://localhost:9393/'
      c.scope          = ['offline_access', 'publish_stream']
    end
  end

  subject { OpenAuth2::Client.new(config) }

  context '#get' do
    it 'makes public request' do
      VCR.use_cassette('fb/cocacola') do
        request = subject.get(:path => '/cocacola')
        request.status.should == 200
      end
    end

    it 'makes private request if #access_token' do
      subject.configure do |c|
        c.access_token = Creds::Facebook::AccessToken
      end

      VCR.use_cassette('fb/me') do
        request = subject.get(:path => '/me/likes')
        request.status.should == 200
      end
    end
  end
end
