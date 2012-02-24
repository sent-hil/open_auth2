module OpenAuth2

  # Used to get Access/Refresh tokens from OAuth server.
  class Token
    extend DelegateToConfig
    include Connection

    # Use it to set @config. Unlike Client, no error is raised since
    # this is not part of public api. This will be called from
    # Client#token internally only.
    #
    # Yields: self.
    #
    # Returns: self.
    #
    def initialize(config=nil)
      @config      = config
      @faraday_url = authorize_url

      self
    end
  end
end
