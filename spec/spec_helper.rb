require_relative '../lib/open_auth2'

require 'pry'

require 'vcr'
require 'timecop'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.stub_with :fakeweb
end

require 'yaml'
Creds = YAML.load_file('spec/fixtures/creds.yml')

def facebook_config
  OpenAuth2::Config.new do |c|
    c.provider = OpenAuth2::Provider::Facebook
    c.client_id = Creds['Facebook']['ClientId']
    c.client_secret = Creds['Facebook']['ClientSecret']
    c.code = Creds['Facebook']['Code']
    c.redirect_uri = 'http://localhost:9393/'
    c.scope = ['offline_access', 'publish_stream']
  end
end

def google_config
  OpenAuth2::Config.new do |c|
    c.provider = OpenAuth2::Provider::Google
    c.client_id = Creds['Google']['ClientId']
    c.client_secret = Creds['Google']['ClientSecret']
    c.access_token = Creds['Google']['AccessToken']
    c.refresh_token = Creds['Google']['RefreshToken']
    c.redirect_uri = 'http://localhost:9393/google/callback'
    c.path_prefix = '/calendar/v3'
    c.scope = ['https://www.googleapis.com/auth/calendar']
  end
end
