module OpenAuth2

  # Used to get Access/Refresh tokens from OAuth server.
  class Token
    extend DelegateToConfig
    include Connection

    # Use it to set @config. Unlike Client, no error is raised since
    # this is not part of public api. This will be called from
    # Client#token internally only.
    #
    # Accepts:
    #   config: OpenAuth2::Config object
    #
    # Returns: self.
    #
    def initialize(config)
      @config      = config
      @faraday_url = authorize_url

      self
    end

    # Packages the info from config & passed in arguments into an url
    # that user has to visit to authorize this app.
    #
    # Examples:
    #   token.build_code_url
    #   #=> 'http://...'
    #
    #   # or
    #   token.build_code_url(:scope => 'publish_stream')
    #
    # Accepts:
    #   params: (optional) Hash of additional config to be bundled into
    #           the url.
    #
    # Returns: String (url).
    #
    def build_code_url(params={})
      url = URI::HTTPS.build(:host  => host,
                             :path  => authorize_path,
                             :query => encoded_body(params))

      url.to_s
    end

    private

    def host
      URI.parse(code_url).host
    end

    def encoded_body(params)
      URI.encode_www_form(url_body_hash(params))
    end

    def url_body_hash(params)
      joined_scope = scope.join(',') if scope.respond_to?(:join)

      {
        :response_type => response_type,
        :client_id     => client_id,
        :redirect_uri  => redirect_uri,
        :scope         => joined_scope
      }.merge(params)
    end
  end
end
