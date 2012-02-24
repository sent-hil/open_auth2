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
      body   = build_body(params)

      params = URI.encode_www_form(body)
      host   = URI.parse(code_url).host
      output = URI::HTTPS.build(:host => host,
                                :path => authorize_path,
                                :query => params)

      output.to_s
    end

    private

    def build_body(params)
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
