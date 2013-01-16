require 'spec_helper'

describe 'Google Client' do
  let(:config) do
    google_config
  end

  subject { OpenAuth2::Client.new(config) }

  context '#get' do
    it 'makes private request' do
      VCR.use_cassette('goog/list') do
        request = subject.get('/users/me/calendarList')
        request.status.should == 200
      end
    end
  end

  context '#post' do
    let(:post_url) do
      '/calendar/v3/calendars/openauth2@gmail.com/events'
    end

    let(:body) do
      "{\"summary\":\"From OpenAuth2\",\"start\":{\"dateTime\":\"2012-03-01T10:00:00.000-07:00\"},\"end\":{\"dateTime\":\"2012-03-02T10:25:00.000-07:00\"}}"
    end

    it 'POST request' do
      content_type = 'application/json'

      VCR.use_cassette('goog/post') do
        request = subject.post(post_url,
                            :body         => body,
                            :content_type => content_type)
        request.status.should == 200
      end
    end

    it 'POST request via #run_request' do
      header   = {"Content-Type" => "application/json"}
      full_url = "#{post_url}?access_token=#{Creds['Google']['AccessToken']}"

      VCR.use_cassette('goog/post') do
        request = subject.run_request(:verb   => :post,
                                      :path   => full_url,
                                      :body   => body,
                                      :header => header)
        request.status.should == 200
      end
    end
  end
end
