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
    end
  end
end
