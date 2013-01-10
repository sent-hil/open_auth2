module OpenAuth2
  # Client/Token use this to make the actual requests.
  # Since some servers have seperate endpoints for authorization
  # & api requests, we use @faraday_url to store that info.
  module Connection
    def self.included(base)
      base.class_eval do
        attr_accessor :faraday_url
      end
    end

    # Yields: Faraday object, so user can choose their own
    # middleware.
    #
    # Examples:
    #   config = OpenAuth2::Config.new
    #   client = OpenAuth2::Client.new(config)
    #
    #   client.connection do
    #     response :logger
    #   end
    #
    # Returns: Faraday object.
    def connection(&blk)
      @connection ||= Faraday.new(:url => @faraday_url) do |builder|
        builder.request :url_encoded
        builder.adapter :net_http
        builder.instance_eval(&blk) if block_given?
      end

      @connection
    end
  end
end
