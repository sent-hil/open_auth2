module OpenAuth2
  module Provider

    # Contains all possible Options keys. Config uses this to define
    # methods.
    #
    module Base
      Keys = [
        :client_id,
        :client_secret,
        :code,
        :authorize_url,
        :redirect_uri,
        :code_url,
        :authorize_path,
        :token_path,
        :access_token,
        :refresh_token,
        :response_type,
        :access_token_grant_name,
        :refresh_token_grant_name,
        :refresh_token_name,
        :scope,
        :endpoint,
        :path_prefix,
        :token_expires_at,
        :token_arrived_at,
      ]
    end
  end
end
