module OpenAuth2
  module Provider

    # Contains the default Options, which is copied to Config on
    # #initialize. We can then choose another provider or overwrite
    # them individually.
    #
    class Default
      attr_accessor :config

      def initialize(config)
        @config = config
      end

      def options
        {
          :response_type            => 'code',
          :access_token_grant_name  => 'authorization_code',
          :refresh_token_grant_name => 'refresh_token',
          :refresh_token_name       => :refresh_token,
          :scope                    => [],
        }
      end

      def parse(response_body)
        response_body
      end

      def post(hash)
        request(:post, hash)
      end

      def put(hash)
        request(:put, hash)
      end

      private

      # Abstracts out POST, PUT requests.
      def request(verb, hash)
        access_token = hash.delete(:access_token) || config.access_token

        hash[:connection].send(verb) do |conn|
          if hash[:content_type]
            conn.headers["Content-Type"] = hash[:content_type]
          end

          conn.url(hash[:path], :access_token => access_token)
          conn.body = hash[:body]
        end
      end
    end
  end
end
