require_relative '../lib/open_auth2'
require 'json'

@code          = ''
@client_id     = ''
@client_secret = ''
@access_token  = ''
@post_email    = ''

@config = OpenAuth2::Config.new do |c|
  c.provider       = :google
  c.code           = @code
  c.client_id      = @client_id
  c.client_secret  = @client_secret
  c.access_token   = @access_token
  c.scope          = ['https://www.googleapis.com/auth/calendar']
  c.redirect_uri   = 'http://localhost:9393/google/callback'
  c.path_prefix    = '/calendar/v3'
end

@client = OpenAuth2::Client.new do |c|
  c.config = @config
end

@token = @client.token

# get request
#@list = @client.get(:path => '/users/me/calendarList')

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
full_url = "#{post_url}?access_token=#{@access_token}"

# post request via #run_request
@client.run_request(:verb   => :post,
                    :path   => full_url,
                    :body   => body,
                    :header => header)
