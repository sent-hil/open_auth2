require 'open_auth2'
require 'spec_helper'

describe 'Facebook Token' do
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

  subject do
    OpenAuth2::Token.new(config)
  end

  context '#build_code_url' do
    it 'returns url' do
      url = "https://www.facebook.com/dialog/oauth?response_type=code&client_id=225722397503003&redirect_uri=http%3A%2F%2Flocalhost%3A9393%2F&scope=offline_access%2Cpublish_stream"

      subject.build_code_url.should == url
    end

    it 'accepts params' do
      url = "https://www.facebook.com/dialog/oauth?response_type=code&client_id=225722397503003&redirect_uri=http%3A%2F%2Flocalhost%3A9393%2F&scope=publish_stream"

      subject.build_code_url(:scope => 'publish_stream').should == url
    end
  end
end
