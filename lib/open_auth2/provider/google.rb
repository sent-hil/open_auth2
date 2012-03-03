module OpenAuth2
  module Provider
    module Google
      Options = {
        :authorize_url  => 'https://accounts.google.com',
        :code_url       => 'https://accounts.google.com',
        :authorize_path => '/o/oauth2/auth',
        :redirect_uri   => 'http://localhost:9393/google/callback',
        :token_path     => '/o/oauth2/token',
        :endpoint       => 'https://www.googleapis.com'
      }

      def self.parse(config, body)
        json                        = JSON.parse(body)

        config.access_token         = json['access_token']
        config.token_arrived_at     = Time.now
        config.token_expires_at     = Time.now+3600

        # google sends refresh_token when getting access_token, but not
        # when refreshing
        #
        if config.refresh_token.empty?
          config.refresh_token = json['refresh_token']
        end
      end
    end
  end
end
