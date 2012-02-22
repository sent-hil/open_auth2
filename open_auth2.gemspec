# -*- encoding: utf-8 -*-
require File.expand_path('../lib/open_auth2.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = "OpenAuth2"
  s.version     = OpenAuth2::VERSION
  s.authors     = ["Senthil A"]
  s.email       = ["senthil196@gmail.com"]
  s.homepage    = "https://github.com/senthilnambi/OpenAuth2"
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "OpenAuth2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 2.8'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'simplecov', '~> 0.5'

  # = MANIFEST =
  s.files = %w[

  ]
  # = MANIFEST =
end
