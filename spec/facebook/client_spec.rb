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
end
