module OpenAuth2
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
    #   config - (optional) OpenAuth2::Config object
    #
    # Examples:
    #   config = OpenAuth2::Config.new
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

      raise NoConfigObject      unless @config
      raise UnknownConfigObject unless @config.is_a?(OpenAuth2::Config)

      # endpoint is where the api requests are made
      @faraday_url = endpoint

      self
    end
  end
end
