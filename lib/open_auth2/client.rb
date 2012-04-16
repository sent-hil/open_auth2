module OpenAuth2

  # Used to make GET/POST requests to OAuth server.
  class Client
    extend DelegateToConfig
    include Connection

    # Use it to set @config. Will raise error if no @config or wrong
    # @config. We rely on Config for all Options info, so its important
    # it is set right.
    #
    # Yields: self.
    #
    # Accepts:
    #   config: (optional) OpenAuth2::Config object
    #
    # Examples:
    #   config = OpenAuth2::Config.new do |c|
    #     c.provider = :facebook
    #   end
    #
    #   # set via block
    #   OpenAuth2::Client.new do |c|
    #     c.config = config
    #   end
    #
    #   # or pass it as an argument
    #   OpenAuth2::Client.new(config)
    #
    # Returns: self.
    #
    def initialize(config=nil)
      @config = config

      yield self if block_given?

      # endpoint is where the api requests are made
      @faraday_url = endpoint
    end

    # Yields: self, use it to set/change config after #initialize.
    # Mainly for setting access_token and refresh_token. Will raise
    # Config related errors same as #initialize.
    #
    # Examples:
    #   client = OpenAuth2::Client.new
    #
    #   client.configure do |c|
    #     c.access_token  = :access_token
    #     c.refresh_token = :refresh_token
    #   end
    #
    # Returns: self.
    #
    def configure
      yield self

      self
    end

    # We use this to get & refresh access/refresh tokens.
    #
    # Returns: Token object.
    #
    def token
      @token ||= Token.new(config)
    end

    # Examples:
    #   client.build_code_url
    #   #=> 'http://...'
    #
    #   # or
    #   client.build_code_url(:scope => 'publish_stream')
    #
    # Accepts:
    #   params: (optional) Hash of additional config to be bundled into
    #           the url.
    #
    # Returns: String (url).
    #
    def build_code_url(params={})
      token.build_code_url(params)
    end

    # Makes GET request to OAuth server via Faraday. If access_token
    # is available, we pass that along to identify ourselves.
    #
    # Accepts:
    #   hash
    #     :path - (required)
    #
    # Examples:
    #   client.get(:path => '/cocacola')
    #   client.get(:path => '/cocacola', :limit => 1)
    #
    # Returns: Faraday response object.
    #
    def get(hash)
      connection.get do |conn|
        path = hash.delete(:path)

        if path_prefix
          path = "#{path_prefix}#{path}"
        end

        hash.merge!(:access_token => access_token) if access_token

        conn.url(path, hash)
      end
    end

    # Makes POST request to OAuth server via Faraday.
    #
    # Accepts:
    #   hash
    #     :path         - (required)
    #     :content_type - (optional)
    #     :body         - (optional)
    #
    # Examples:
    #   # using query params (fb uses this)
    #   client.post(:path => "/me/feed?message='From OpenAuth2'")
    #
    #   # using body (google uses this)
    #   body = JSON.dump(:message => "From OpenAuth2)
    #   client.post(:path         => "/me/feed,
    #               :body         => body,
    #               :content_type => 'application/json')
    #
    # Returns: Faraday response object.
    #
    def post(hash)
      connection.post do |conn|
        if hash[:content_type]
          conn.headers["Content-Type"] = hash[:content_type]
        end

        conn.url(hash[:path], :access_token => access_token)
        conn.body = hash[:body]
      end
    end

    # Makes request to OAuth server via Faraday#run_request. It takes
    # Hash since I can never remember the order in which to pass the
    # arguments.
    #
    # Accepts:
    #   hash
    #     :verb   - (required) GET/POST etc.
    #     :path   - (required)
    #     :body   - (optional)
    #     :header - (optional)
    #
    # Examples:
    #   # public GET request
    #   path = "https://graph.facebook.com/cocacola"
    #   client.run_request(verb: :get, path: path, body: nil, header: nil)
    #
    #   # private GET request
    #   path = "/me/likes?access_token=..."
    #   client.run_request(verb: :get, path: path, body: nil, header: nil)
    #
    # Returns: Faraday response object.
    #
    def run_request(hash)
      connection.run_request(hash[:verb], hash[:path], hash[:body],
                             hash[:header])
    end
  end
end
