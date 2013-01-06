require_relative '../lib/open_auth2'
require 'json'

require 'yaml'
Creds = YAML.load_file('spec/fixtures/creds.yml')

Code         = nil
AccessToken  = 'ya29.AHES6ZRL6dKYn5HvssNQvH15KXTc76jCd9KC6Wfsir74whQ'
RefreshToken = '1/2hTXHN9FULj7v_hVOIoyHn6BpOQS6uDOw-xllInXnTU'
PostEmail    = 'senthil196@gmail.com'

@config = OpenAuth2::Config.new do |c|
  c.provider       = :google
  c.client_id      = Creds['Google']['ClientId']
  c.client_secret  = Creds['Google']['ClientSecret']
  c.code           = Code
  c.access_token   = AccessToken
  c.refresh_token  = RefreshToken
  c.scope          = ['https://www.googleapis.com/auth/calendar']
  c.redirect_uri   = 'http://localhost:9393/google/callback'
  c.path_prefix    = '/calendar/v3'
end

@client = OpenAuth2::Client.new do |c|
  c.config = @config
end

#@token = @client.token

#params = {:approval_prompt => 'force', :access_type => 'offline'}
#@url  = @token.build_code_url(params)

# get request
@list = @client.get('/users/me/calendarList')

@post_url = "/calendar/v3/calendars/#{PostEmail}/events"
@body     = {
  "summary" => "From OpenAuth2",
  "start"   => {"dateTime"=>"2012-10-03T10:00:00.000-07:00"},
  "end"     => {"dateTime"=>"2012-10-03T10:25:00.000-07:00"}
}
@body = JSON.dump(@body)

# post request
def make_request
  @response  = @client.post(@post_url, :body => @body,
                            :content_type => "application/json")
end

#header   = {"Content-Type" => "application/json"}
#full_url = "#{post_url}?access_token=#{AccessToken}"

# post request via #run_request
#@client.run_request(:verb   => :post,
                    #:path   => full_url,
                    #:body   => body,
                    #:header => header)
