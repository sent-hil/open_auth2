require_relative '../lib/open_auth2'

require 'yaml'
Creds = YAML.load_file('spec/fixtures/creds.yml')

Code        = Creds['Facebook']['Code']
AccessToken = Creds['Facebook']['AccessToken']

@config = OpenAuth2::Config.new do |c|
  c.provider       = OpenAuth2::Provider::Facebook
  c.client_id      = Creds['Facebook']['ClientId']
  c.client_secret  = Creds['Facebook']['ClientSecret']
  c.code           = Code
  c.access_token   = AccessToken
  c.redirect_uri   = 'http://localhost:9393/'
  c.scope          = ['publish_stream']
end

@client = OpenAuth2::Client.new(@config)
@token  = OpenAuth2::Token.new(@config)
@url    = @token.build_code_url
