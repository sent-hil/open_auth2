module OpenAuth2
  module Provider
    class Facebook
      extend OpenAuth2::PluginDsl

      options :authorize_url => 'https://graph.facebook.com',
          :code_url => 'https://www.facebook.com',
          :refresh_token_grant_name => 'fb_exchange_token',
          :refresh_token_name => 'fb_exchange_token',
          :authorize_path => '/dialog/oauth',
          :token_path => '/oauth/access_token',
          :endpoint => 'https://graph.facebook.com'

      before_client_post do |params|
        body = URI.encode_www_form(params[:body])
        params[:path] += "?#{body}"
        params.delete(:body)
      end

      after_token_post do |response_body, config|
        resp = response_body.gsub('access_token=', '')
        resp = resp.split('&expires=')

        config.access_token     = resp[0]
        config.refresh_token    = resp[0]
        config.token_arrived_at = Time.now
        config.token_expires_at = (Time.now.to_date+60).to_time
      end
    end
  end
end
