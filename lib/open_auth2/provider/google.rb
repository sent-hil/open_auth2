module OpenAuth2
  module Provider
    class Google
      extend OpenAuth2::PluginDsl

      options :authorize_url => 'https://accounts.google.com',
        :code_url => 'https://accounts.google.com',
        :authorize_path => '/o/oauth2/auth',
        :redirect_uri => 'http://localhost:9393/google/callback',
        :token_path => '/o/oauth2/token',
        :endpoint => 'https://www.googleapis.com'

      after_token_post do |response_body, config|
        json                    = JSON.parse(response_body)
        config.access_token     = json['access_token']
        config.token_arrived_at = Time.now
        config.token_expires_at = Time.now+3600

        # google sends refresh_token when getting
        # access_token, but not when refreshing
        unless config.refresh_token
          config.refresh_token = json['refresh_token']
        end
      end
    end
  end
end
