require_relative '../lib/open_auth2'

ClientId = '216091171753850'
ClientSecret = '56f751bef00d6d21e858566b873ac8f8'
Code = ''
AccessToken = ''

@config = OpenAuth2::Config.new do |c|
  c.provider       = :facebook
  c.client_id      = ClientId
  c.client_secret  = ClientSecret
  c.code           = Code
  c.access_token   = AccessToken
  c.redirect_uri   = 'http://localhost:9393/'
  c.scope          = ['manage_pages', 'read_insights']
end

@client = OpenAuth2::Client.new(@config)
@url    = @client.build_code_url
@token  = @client.token
