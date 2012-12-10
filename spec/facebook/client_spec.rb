require 'open_auth2'
require 'spec_helper'

describe 'Facebook Client' do
  let(:config) do
    facebook_config
  end

  subject { OpenAuth2::Client.new(config) }

  context '#get' do
    it 'makes public request' do
      VCR.use_cassette('facebook/cocacola') do
        request = subject.get(:path => '/cocacola')
        request.status.should == 200
      end
    end

    it 'makes private request if #access_token' do
      subject.configure do |c|
        c.access_token = Creds['Facebook']['AccessToken']
      end

      VCR.use_cassette('facebook/me') do
        request = subject.get(:path => '/me/likes')
        request.status.should == 200
      end
    end
  end

  context '#run_request' do
    it 'makes public GET request' do
      VCR.use_cassette('facebook/cocacola') do
        request = subject.run_request(:verb => :get, :path => '/cocacola',
                                      :body => nil , :header => nil)
        request.status.should == 200
      end
    end

    it 'makes private GET request' do
      VCR.use_cassette('facebook/me') do
        path = "/me/likes?access_token=#{Creds['Facebook']['AccessToken']}"
        request = subject.run_request(:verb => :get, :path   => path,
                                      :body => nil , :header => nil)
        request.status.should == 200
      end
    end
  end

  context '#post' do
    before do
      subject.configure do |c|
        c.access_token = Creds['Facebook']['AccessToken']
      end
    end

    let(:post_url) do
      "/me/feed"
    end

    it 'makes request' do
      VCR.use_cassette('facebook/post') do
        content_type = 'application/json'
        request = subject.post(:path    => post_url,
                               :message => 'From OpenAuth2')
        request.status.should == 200
      end
    end
  end
end
