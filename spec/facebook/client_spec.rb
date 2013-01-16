require 'spec_helper'

describe 'Facebook Client' do
  let(:config) do
    facebook_config
  end

  subject { OpenAuth2::Client.new(config) }

  context '#get' do
    it 'makes public request' do
      VCR.use_cassette('facebook/cocacola') do
        request = subject.get('/cocacola')
        request.status.should == 200
      end
    end

    it 'makes private request if #access_token' do
      subject.access_token = Creds['Facebook']['AccessToken']

      VCR.use_cassette('facebook/me') do
        request = subject.get('/me/likes')
        request.status.should == 200
      end
    end
  end

  context '#post' do
    before do
      subject.access_token = Creds['Facebook']['AccessToken']
    end

    it 'makes request' do
      VCR.use_cassette('facebook/post') do
        content_type = 'application/json'
        request = subject.post('/me/feed',
                    :body => {:message => 'From OpenAuth2'})
        request.status.should == 200
      end
    end
  end
end
