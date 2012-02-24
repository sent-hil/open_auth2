require_relative '../lib/open_auth2'

@default = OpenAuth2::Config.new do |c|
  c.provider = :default
end

@fb = OpenAuth2::Config.new do |c|
  c.provider = :facebook
end
