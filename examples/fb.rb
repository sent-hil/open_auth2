require_relative '../lib/open_auth2'

@config = OpenAuth2::Config.new do |c|
  c.provider = :facebook
end

@client = OpenAuth2::Client.new(@config)

@coke = @client.get(:path => '/cocacola')
