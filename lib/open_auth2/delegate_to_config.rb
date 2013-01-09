module OpenAuth2

  # Helper module that Client/Token extend so they can have
  # access to Options methods. We delegate those methods to
  # Config object.
  module DelegateToConfig
    def self.extended(base)
      base.send(:attr_accessor, :config)
      base.delegate_to_config
    end

    def delegate_to_config
      OpenAuth2::Provider::Base::Keys.each do |key|
        define_method(key) do
          @config.send(key)
        end

        define_method("#{key}=") do |value|
          @config.send("#{key}=", value)
        end
      end
    end
  end
end
