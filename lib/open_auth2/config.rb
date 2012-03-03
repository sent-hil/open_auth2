module OpenAuth2

  # Holds the info required to make a valid request to an OAuth server.
  class Config
    attr_accessor *Provider::Base::Keys
    attr_reader :provider, :provider_const, :provider_string

    # Sets provider to default.
    #
    # Yields: self, use it to set config.
    #
    # Examples:
    #   OpenAuth2::Config.new do |c|
    #     c.provider = :default
    #   end
    #
    # Returns: self.
    #
    def initialize
      set_default_as_provider

      yield self if block_given?
    end

    # Yields: self, use it to set/change config after #initialize.
    #
    # Examples:
    #   config = OpenAuth2::Config.new
    #
    #   config.configure do |c|
    #     c.provider = :google
    #   end
    #
    # Returns: self.
    #
    def configure
      yield self if block_given?
    end

    # Finds provider's module & copies its Options key/values to here.
    #
    # Accepts:
    #   name - String/Symbol/Constant.
    #
    def provider=(name)
      set_provider_vars(name)
      copy_provider_keys
    end

    # Removes all overwritten config & resets provider to default.
    def reset_provider
      remove_instance_vars
      set_default_as_provider
    end

    def parse(response_body)
      @provider_const.parse(self, response_body)
    end

    private

    def set_default_as_provider
      self.provider = :default
    end

    def set_provider_vars(name)
      @provider        = name
      @provider_string = name.to_s
      @provider_const  = constantize_provider_string
    end

    def constantize_provider_string
      provider_string = @provider_string.camelize
      full_string     = "OpenAuth2::Provider::#{provider_string}"

      @provider_const = full_string.constantize
    rescue NameError => error
      if error.to_s =~ /uninitialized constant/
        raise UnknownProvider, "Known Providers: #{known_providers}"
      end
    end

    def known_providers
      known_providers = OpenAuth2::Provider.constants
      known_providers.delete(:Base)

      known_providers
    end

    def copy_provider_keys
      @provider_const::Options.each do |key,value|
        instance_variable_set("@#{key}", value)
      end
    end

    def remove_instance_vars
      instance_variables.each do |var|
        remove_instance_variable var
      end
    end
  end
end
