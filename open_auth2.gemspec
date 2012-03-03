# -*- encoding: utf-8 -*-
require './lib/open_auth2/version'

Gem::Specification.new do |s|
  s.name              = "OpenAuth2"
  s.version           = OpenAuth2::VERSION
  s.authors           = ["Senthil A"]
  s.email             = ["senthil196@gmail.com"]
  s.homepage          = "https://github.com/senthilnambi/OpenAuth2"
  s.description       = %q{OpenAuth2 is a thin OAuth2 wrapper written on top of Faraday in Ruby.}
  s.summary           = %q{OpenAuth2 is a thin OAuth2 wrapper written on top of Faraday in Ruby. The goal is a simple, well documented, easy to use interface for all your OAuth2 needs.}

  s.rubyforge_project = "OpenAuth2"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end

  s.require_paths     = ["lib"]

  s.add_dependency 'faraday',             '~> 0.7'
  s.add_dependency 'activesupport',       '~> 3.2'

  s.add_development_dependency 'rake',    '~> 0.9'
  s.add_development_dependency 'rspec',   '~> 2.8'
  s.add_development_dependency 'vcr',     '~> 1.11'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'timecop', '~> 0.3'

  # = MANIFEST =
  s.files = %w[
  ]
  # = MANIFEST =
end
