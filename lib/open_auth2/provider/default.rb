module OpenAuth2
  module Provider

    # Contains the default Options, which is copied to Config on
    # #initialize. We can then choose another provider or overwrite
    # them individually.
    #
    module Default
      Options = {
        :response_type            => 'code',
        :access_token_grant_name  => 'authorization_code',
        :refresh_token_grant_name => 'refresh_token',
        :refresh_token_name       => :refresh_token,
        :scope                    => [],
      }
    end
  end
end
