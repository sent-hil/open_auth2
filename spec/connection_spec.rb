require 'spec_helper'

describe OpenAuth2::Connection do
  context 'facebook' do
    it 'makes GET request' do
      VCR.use_cassette('facebook/cocacola') do
        params = {:url =>
          'https://graph.facebook.com/cocacola'}
        resp = described_class.new(:get, params).fetch

        resp.status.should == 200
      end
    end

    it 'makes POST request' do
      VCR.use_cassette('facebook/post') do
        params = {:url =>
          "https://graph.facebook.com/me/feed?message=From+OpenAuth2&access_token=#{Creds['Facebook']['AccessToken']}"}
        resp = described_class.new(:post, params).fetch

        resp.status.should == 200
      end
    end
  end

  context 'google' do
    it 'makes GET request' do
      VCR.use_cassette('goog/list') do
        params = {:url =>
          "https://www.googleapis.com:443/calendar/v3/users/me/calendarList?access_token=#{Creds['Google']['AccessToken']}"}
        resp = described_class.new(:get, params).fetch

        resp.status.should == 200
      end
    end

    it 'makes POST request' do
      VCR.use_cassette('goog/post') do
        params = {:body => "{\"summary\":\"From OpenAuth2\",\"start\":{\"dateTime\":\"2012-03-01T10:00:00.000-07:00\"},\"end\":{\"dateTime\":\"2012-03-02T10:25:00.000-07:00\"}}",
          :headers => {'Content-Type' => 'application/json'},
          :url => "https://www.googleapis.com/calendar/v3/calendars/openauth2@gmail.com/events?access_token=#{Creds['Google']['AccessToken']}"}
        resp = described_class.new(:post, params).fetch

        resp.status.should == 200
      end
    end
  end
end
