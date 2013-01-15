module OpenAuth2
  module PluginDsl
    class << self
      attr_reader :providers
    end

    def self.extended(klass)
      @providers ||= []
      @providers << klass

      klass.send(:include, InstanceMethods)
    end

    def options(opts={})
      return @options if opts.empty?

      @options = opts
    end

    def self.store_callbacks(*names)
      names.each do |name|
        define_method(name) do |&blk|
          if blk
            instance_variable_set("@#{name}", blk)
          end

          instance_variable_get("@#{name}")
        end
      end
    end

    store_callbacks :before_client_post, :after_client_post,
      :before_token_post, :after_token_post,
      :before_refresh_token_post, :after_refresh_token_post

    module InstanceMethods
      def initialize(config)
        @config = config
      end

      def method_missing(name, *args, &blk)
        self.class.send(name, *args, &blk)
      end
    end
  end
end
