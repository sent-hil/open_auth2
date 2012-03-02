require_relative '../lib/open_auth2'
require 'json'

@access_token  = '77848792642.apps.googleusercontent.com'
@refresh_token = 'ZtXPd6DkYYhIbmRQxwLaDUqp'

@config = OpenAuth2::Config.new do |c|
  c.provider       = :google
  c.access_token   = @access_token
  c.refresh_token  = @refresh_token
  c.scope          = ['https://www.googleapis.com/auth/calendar']
  c.redirect_uri   = 'http://localhost:9393/google/callback'
  c.path_prefix    = '/calendar/v3'
end

@client = OpenAuth2::Client.new do |c|
  c.config = @config
end

# get request
@p = proc { @client.get(:path => '/users/me/calendarList') }
