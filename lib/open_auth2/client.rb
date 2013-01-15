module OpenAuth2
  # Makes GET/POST requests.
  class Client
    extend DelegateToConfig
    include Connection

    # Use to set config.
    #
    # Accepts:
    #   config - (optional) OpenAuth2::Config object.
    #
    # Examples:
    #   config = OpenAuth2::Config.new do |c|
    #     c.provider = OpenAuth2::Provider::Facebook
    #   end
    #
    #   OpenAuth2::Client.new(config)
    def initialize(config=OpenAuth2::Config.new)
      @config = config
      @faraday_url = endpoint
    end

    # Makes GET request to OAuth server. If access_token
    # is available we pass that along to identify request.
    #
    # Accepts:
    #   path - String
    #   params - Hash, key/values are encoded as params
    #
    # Examples:
    #   client.get('/cocacola')
    #   client.get('/cocacola', :limit => 1)
    #
    # Returns: Faraday response object.
    def get(path, params={})
      request(:get, params.merge(:path => path))
    end

    # Same as `get`.
    def delete(path, params={})
      request(:delete, params.merge(:path => path))
    end

    # Makes POST request.
    #
    # Accepts:
    #   path - String
    #   params
    #     :body - (optional)
    #     :content_type - (optional)
    #
    # Examples:
    #
    #   # using query params (fb uses this)
    #   # params passed via hash are encoded & sent w/ req
    #   #
    #   client.post('/me/feed', :message => 'OpenAuth2')
    #
    #   # using body (google uses this)
    #   body = JSON.dump(:message => 'From OpenAuth2')
    #   client.post('/me/feed', :body => body,
    #               :content_type => 'application/json')
    #
    # Returns: Faraday response object.
    def post(path, params={})
      args = {:connection => connection, :path => path}
      config.post(params.merge(args))
    end

    # Same as `post`.
    def put(path, params={})
      args = {:connection => connection, :path => path}
      config.put(params.merge(args))
    end

    # Makes request to via Faraday#run_request. It takes
    # Hash since I can never remember the order in which to
    # pass the arguments.
    #
    # Accepts:
    #   params
    #     :verb   - (required) GET/POST etc.
    #     :path   - (required)
    #     :body   - (optional)
    #     :header - (optional)
    #
    # Examples:
    #   # public GET request
    #   path = "https://graph.facebook.com/cocacola"
    #   client.run_request(verb: :get, path: path,
    #                      body: nil, header: nil)
    #
    #   # private GET request
    #   path = "/me/likes?access_token=..."
    #   client.run_request(verb: :get, path: path,
    #                      body: nil, header: nil)
    #
    # Returns: Faraday response object.
    def run_request(params)
      connection.run_request(params[:verb], params[:path],
                             params[:body], params[:header])
    end

    private

    # Abstracts out GET, DELETE requests.
    def request(verb, params)
      connection.send(verb) do |conn|
        path = params.delete(:path)

        if path_prefix
          path = "#{path_prefix}#{path}"
        end

        if access_token
          params.merge!(:access_token => access_token)
        end

        conn.url(path, params)
      end
    end
  end
end
