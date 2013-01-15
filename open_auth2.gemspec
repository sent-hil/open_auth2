# -*- encoding: utf-8 -*-
require './lib/open_auth2/version'

Gem::Specification.new do |s|
  s.name              = "open_auth2"
  s.version           = OpenAuth2::VERSION
  s.authors           = ["sent-hil"]
  s.email             = ["me@sent-hil.com"]
  s.homepage          = "https://github.com/sent-hil/OpenAuth2"
  s.description       = %q{OpenAuth2 is a simple OAuth2 client.}
  s.summary           = %q{OpenAuth2 is a simple OAuth2 client written on top of Faraday in Ruby. The goal is a simple, well documented, easy to use interface for all your OAuth2 needs.}

  s.rubyforge_project = "OpenAuth2"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end

  s.require_paths     = ["lib"]

  s.add_dependency 'faraday',             '~> 0.7'
  s.add_dependency 'json'

  if RUBY_PLATFORM == 'java'
    s.add_dependency 'json'
    s.add_dependency 'jruby-openssl'
  end

  s.add_development_dependency 'rake',    '~> 0.9'
  s.add_development_dependency 'rspec',   '~> 2.8'
  s.add_development_dependency 'vcr',     '1.11.3'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'timecop', '~> 0.3'
  s.add_development_dependency 'pry',     '~> 0.9'
  s.add_development_dependency 'capybara', '~> 2.0.1'

  # = MANIFEST =
  s.files = %w[
    Gemfile
    License
    Rakefile
    Readme.markdown
    Spec.markdown
    examples/google.rb
    lib/open_auth2.rb
    lib/open_auth2/client.rb
    lib/open_auth2/config.rb
    lib/open_auth2/connection.rb
    lib/open_auth2/delegate_to_config.rb
    lib/open_auth2/provider.rb
    lib/open_auth2/provider/base.rb
    lib/open_auth2/provider/default.rb
    lib/open_auth2/provider/facebook.rb
    lib/open_auth2/provider/google.rb
    lib/open_auth2/token.rb
    lib/open_auth2/version.rb
    open_auth2.gemspec
    spec/client_spec.rb
    spec/config_spec.rb
    spec/facebook/client_spec.rb
    spec/facebook/token_spec.rb
    spec/fixtures/creds.yml
    spec/fixtures/vcr/facebook/access_token.yml
    spec/fixtures/vcr/facebook/cocacola.yml
    spec/fixtures/vcr/facebook/me.yml
    spec/fixtures/vcr/facebook/post.yml
    spec/fixtures/vcr/facebook/refresh_token.yml
    spec/fixtures/vcr/goog/access_token.yml
    spec/fixtures/vcr/goog/list.yml
    spec/fixtures/vcr/goog/post.yml
    spec/fixtures/vcr/goog/refresh_token.yml
    spec/google/client_spec.rb
    spec/google/token_spec.rb
    spec/reset_tokens.rb
    spec/spec_helper.rb
    spec/token_spec.rb
  ]
  # = MANIFEST =
end
