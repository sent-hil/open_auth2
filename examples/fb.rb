require_relative '../lib/open_auth2'

ClientId     = '369754433115833'
ClientSecret = '117d2e4932154c8c408d3d170c81c2dc'
Code         = ''
AccessToken  = ''

@config = OpenAuth2::Config.new do |c|
  c.provider       = :facebook
  c.client_id      = ClientId
  c.client_secret  = ClientSecret
  c.code           = Code
  c.access_token   = AccessToken
  c.redirect_uri   = 'http://localhost:9393/'
  c.scope          = ['publish_stream']
end

@client = OpenAuth2::Client.new(@config)
@url    = @client.build_code_url
@token  = @client.token
