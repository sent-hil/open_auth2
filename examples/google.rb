require_relative '../lib/open_auth2'
require 'json'

ClientId       = nil
ClientSecret   = nil
Code           = nil
AccessToken    = nil
RefreshToken   = nil

@config = OpenAuth2::Config.new do |c|
  c.provider       = :google
  c.code           = Code
  c.client_id      = ClientId
  c.client_secret  = ClientSecret
  c.scope          = ['https://www.googleapis.com/auth/calendar']
  c.redirect_uri   = 'http://localhost:9393/google/callback'
  c.path_prefix    = '/calendar/v3'
end

@client = OpenAuth2::Client.new do |c|
  c.config = @config
end

@token = @client.token

params = {:approval_prompt => 'force', :access_type => 'offline'}
@url  = @token.build_code_url(params)

# get request
@list = @client.get(:path => '/users/me/calendarList')

post_url = "/calendar/v3/calendars/#{post_email}/events"
body     = {
  "summary" => "From OpenAuth2",
  "start"   => {"dateTime"=>"2012-03-03T10:00:00.000-07:00"},
  "end"     => {"dateTime"=>"2012-03-03T10:25:00.000-07:00"}
}
body = JSON.dump(body)

# post request
@client.post(:path         => post_url,
             :body         => body,
             :content_type => "application/json")

header   = {"Content-Type" => "application/json"}
full_url = "#{post_url}?access_token=#{AccessToken}"

# post request via #run_request
@client.run_request(:verb   => :post,
                    :path   => full_url,
                    :body   => body,
                    :header => header)
