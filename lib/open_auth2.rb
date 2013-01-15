require 'bundler/setup'

require 'faraday'
require 'uri'
require 'json'

require_relative 'open_auth2/provider'
require_relative 'open_auth2/provider/base'
require_relative 'open_auth2/provider/default'
require_relative 'open_auth2/provider/facebook'
require_relative 'open_auth2/provider/google'
require_relative 'open_auth2/delegate_to_config'
require_relative 'open_auth2/config'
require_relative 'open_auth2/connection'
require_relative 'open_auth2/token'
require_relative 'open_auth2/client'

require_relative 'open_auth2/version'

module OpenAuth2
  class UnknownProvider < StandardError; end
end
