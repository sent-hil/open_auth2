module OpenAuth2

  # Holds the info required to make a valid request to an OAuth server.
  class Config
    attr_accessor *Provider::Base::Keys
    attr_reader :provider, :provider_const, :provider_string

    # Use to set config info.
    #
    # Examples:
    #   OpenAuth2::Config.new do |c|
    #     c.provider = :default
    #   end
    #
    def initialize
      set_default_as_provider
      yield self if block_given?
    end

    # Use to set config info.
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

    # Finds provider's module & copies its Options key/value pairs.
    #
    # Accepts:
    #   name - String/Symbol/Constant.
    #
    def provider=(name)
      return unless name

      set_provider_vars(name)
      copy_provider_keys
    end

    # Removes all overwritten config & reset to default.
    def reset_provider
      remove_stored_info
      set_default_as_provider
    end

    # Delegates missing methods to provider.
    def method_missing(name, *args, &blk)
      @provider_const.new(self).send(name, *args)
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
    rescue NameError
      raise UnknownProvider, "Known Providers: #{known_providers}"
    end

    def known_providers
      known_providers = OpenAuth2::Provider.constants
      known_providers.delete(:Base)

      known_providers
    end

    def copy_provider_keys
      @provider_const::new(config).options.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def remove_stored_info
      instance_variables.each do |var|
        remove_instance_variable var
      end
    end
  end
end
