if ENV['RESET_TOKENS']
  require_relative '../lib/open_auth2'

  require 'capybara/rspec'
  require 'pry'

  require 'yaml'
  Creds = YAML.load_file('spec/fixtures/creds.yml')

  describe "ResetToken", :js => true do
    include Capybara::DSL

    it 'Facebook' do
      config = OpenAuth2::Config.new do |c|
        c.provider       = :facebook
        c.client_id      = Creds['Facebook']['ClientId']
        c.client_secret  = Creds['Facebook']['ClientSecret']
        c.code           = Creds['Facebook']['Code']
        c.access_token   = Creds['Facebook']['AccessToken']
        c.redirect_uri   = 'http://localhost:9393/'
        c.scope          = ['publish_stream']
      end

      client = OpenAuth2::Client.new(config)
      url    = client.build_code_url
      token  = client.token

      response = visit('https://www.facebook.com/')
      fill_in :email, :with => ENV['USER']
      fill_in :pass, :with => ENV['PASS']
      click_button 'Log In'

      response = visit(url)
      code = current_url.split('=')[1].split('#')[0]

      config.code = code
      token.get
      access_token = config.access_token

      response = visit(url)
      code = current_url.split('=')[1].split('#')[0]

      Creds['Facebook']['Code'] = code
      Creds['Facebook']['AccessToken'] = access_token

      File.open('spec/fixtures/creds.yml', 'w') do |f|
        f.puts(YAML.dump(Creds))
      end
    end
  end
end
