module OpenAuth2
  module Provider
    class Default
      extend OpenAuth2::PluginDsl

      options :response_type => 'code',
        :access_token_grant_name => 'authorization_code',
        :refresh_token_grant_name => 'refresh_token',
        :refresh_token_name => :refresh_token,
        :scope => []

      after_token_post do |response_body, config|
        response_body
      end
    end
  end
end
