#require 'open_auth2'
#require 'spec_helper'

#describe 'Google Client' do
  #let(:config) do
    #OpenAuth2::Config.new do |c|
      #c.provider       = :Google
      #c.client_id      = Creds::Google::ClientId
      #c.client_secret  = Creds::Google::ClientSecret
      #c.code           = Creds::Google::Code
      #c.access_token   = Creds::Google::AccessToken
      #c.scope          = ['https://www.googleapis.com/auth/calendar']
      #c.redirect_uri   = 'http://localhost:9393/google/callback'
      #c.path_prefix    = '/calendar/v3'
    #end
  #end

  #subject { OpenAuth2::Client.new(config) }

  #context '#get' do
    #it 'makes private request' do
      #VCR.use_cassette('goog/list') do
        #req = subject.get(:path => '/users/me/calendarList')
        #req.status.should == 200
      #end
    #end
  #end
#end
