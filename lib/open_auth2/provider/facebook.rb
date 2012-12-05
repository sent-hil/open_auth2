module OpenAuth2
  module Provider
    class Facebook
      def options
        {
          :authorize_url            => 'https://graph.facebook.com',
          :code_url                 => 'https://www.facebook.com',
          :refresh_token_grant_name => 'fb_exchange_token',
          :refresh_token_name       => 'fb_exchange_token',
          :authorize_path           => '/dialog/oauth',
          :token_path               => 'oauth/access_token',
          :endpoint                 => 'https://graph.facebook.com'
        }
      end

      def parse(config, response_body)
        resp = response_body.gsub('access_token=', '')
        resp = resp.split('&expires=')

        config.access_token     = resp[0]
        config.refresh_token    = resp[0]
        config.token_arrived_at = Time.now
        config.token_expires_at = resp[1]
      end
    end
  end
end
