require 'vcr'
require 'timecop'
require 'fixtures/creds'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.stub_with :fakeweb
end
