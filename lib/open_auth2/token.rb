require_relative 'client'

module OpenAuth2
  # Gets Access/Refresh tokens from OAuth server.
  class Token < Client
    def initialize(config=OpenAuth2::Config.new)
      @config = config
      @endpoint = authorize_url
    end

    # Packages info from config & passed in arguments into an
    # url that user can to visit to authorize this app.
    #
    # Examples:
    #   token.build_code_url
    #   #=> 'http://...'
    #
    #   # or
    #   token.build_code_url(:scope => 'publish_stream')
    #
    # Accepts:
    #   params - (optional) Hash of additional config.
    #
    # Returns: String (url).
    def build_code_url(params={})
      url = URI::HTTPS.build(:host  => host,
                             :path  => authorize_path,
                             :query => encoded_body(params))
      url.to_s
    end

    # Makes request to OAuth server for access token & parses
    # it by delegating to the appropriate provider.
    #
    # Accepts:
    #   params - (optional) Hash of additional config to be
    #             sent with request.
    def get(params={})
      body        = get_body(params)
      raw_request = post(body)

      parse(raw_request)
    end

    # Makes request to OAuth server to refresh the access token.
    #
    # Accepts:
    #   params - (optional) Hash of additional config to be
    #             sent with request.
    def refresh(params={})
      body        = refresh_body(params)
      raw_request = post(body)

      parse(raw_request)
    end

    def token_expired?
      Time.now > token_expires_at
    rescue
      nil
    end

    private

    # We use URI#parse to get rid of those pesky extra /.
    def host
      URI.parse(code_url).host
    end

    def encoded_body(params)
      URI.encode_www_form(url_body(params))
    end

    # Combine default options & user arguments.
    def url_body(params)

      # user can define scope as String or Array
      joined_scope = scope.join(',') if scope.respond_to?(:join)

      {
        :response_type => response_type,
        :client_id     => client_id,
        :redirect_uri  => redirect_uri,
        :scope         => joined_scope
      }.merge(params)
    end

    def get_body(params)
      {
        :client_id      => client_id,
        :client_secret  => client_secret,
        :code           => code,
        :grant_type     => access_token_grant_name,
        :redirect_uri   => redirect_uri
      }.merge(params)
    end

    def refresh_body(params)
       {
         :client_id         => client_id,
         :client_secret     => client_secret,
         :grant_type        => refresh_token_grant_name,
         refresh_token_name => refresh_token
       }.merge(params)
    end

    # Makes the actual request.
    def post(body)
      url = @endpoint + token_path
      params = {
        :headers => {'Content-Type' => 'application/x-www-form-urlencoded', 'Accept' => 'application/json'},
        :url => url,
        :body => body
      }

      Connection.new(:post, params).fetch
    end

    def parse(response)
      config.after_token_post.call(response.body, config)
      response
    end
  end
end
