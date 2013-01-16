module OpenAuth2
  # Makes GET/POST requests.
  class Client
    extend DelegateToConfig

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
      @endpoint = endpoint
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

    def post(path, params={})
      request(:post, params.merge(:path => path))
    end

    # Same as `post`.
    def put(path, params={})
      request(:post, params.merge(:path => path))
    end

    private

    # Abstracts out GET, DELETE requests.
    def request(verb, params)
      params = build_url(params)

      if access_token
        params.merge!(:access_token => access_token)
      end

      Connection.new(verb, params).fetch
    end

    def build_url(params)
      url = ""
      url += endpoint.to_s

      if path_prefix
        url += "#{path_prefix}"
      end

      url += params.delete(:path)
      params.merge!(:url => url)
    end
  end
end
