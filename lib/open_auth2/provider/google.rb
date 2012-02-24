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
    end
  end
end
