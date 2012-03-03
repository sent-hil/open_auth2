module OpenAuth2
  module Provider
    module Facebook
      Options = {
        :authorize_url            => 'https://graph.facebook.com',
        :code_url                 => 'https://www.facebook.com',
        :refresh_token_grant_name => 'fb_exchange_token',
        :refresh_token_name       => 'fb_exchange_token',
        :authorize_path           => '/dialog/oauth',
        :token_path               => 'oauth/access_token',
        :endpoint                 => 'https://graph.facebook.com'
      }

      def self.parse(config, response_body)
        access_token            = response_body.gsub('access_token=', '')
        config.access_token     = access_token
        config.refresh_token    = access_token
        config.token_arrived_at = Time.now
        config.token_expires_at = "60 days?"
      end
    end
  end
end
