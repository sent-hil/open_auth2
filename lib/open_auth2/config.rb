module OpenAuth2
  # Holds the info required to make a valid request.
  class Config
    attr_accessor *Provider::Base::Keys
    attr_reader :provider

    # Use to set config info.
    #
    # Examples:
    #   OpenAuth2::Config.new do |c|
    #     c.provider = OpenAuth2::Provider::Default
    #   end
    def initialize
      set_default_as_provider
      yield self if block_given?
    end

    # Initializes provider & copies its options info.
    #
    # Accepts:
    #   name - Class
    def provider=(name)
      return unless name

      set_provider(name)
      copy_provider_keys
    end

    # Removes all overwritten config & reset to default.
    def reset_provider
      remove_stored_info
      set_default_as_provider
    end

    # Delegates missing methods to provider.
    def method_missing(name, *args, &blk)
      provider.send(name, *args)
    end

    private

    def set_default_as_provider
      self.provider = OpenAuth2::Provider::Default
    end

    def set_provider(name)
      @provider = name.new(self)
    rescue => e
      raise UnknownProvider,
        "Known Providers: #{known_providers}"
    end

    def known_providers
      known_providers = OpenAuth2::Provider.constants
      known_providers.delete(:Base)

      known_providers
    end

    def copy_provider_keys
      provider.options.each do |k,v|
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
