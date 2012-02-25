## Google example

```ruby
require 'open_auth2'
require 'json'

access_token  = 'enter in your own value'
refresh_token = 'enter in your own value'

config = OpenAuth2::Config.new do |c|
  c.provider       = :google
  c.access_token   = access_token
  c.refresh_token  = refresh_token
  c.scope          = ['https://www.googleapis.com/auth/calendar']
  c.redirect_uri   = 'http://localhost:9393/google/callback'
  c.path_prefix    = '/calendar/v3'
end

client = OpenAuth2::Client.new do |c|
  c.config = config
end

# get request
client.get(:path => '/users/me/calendarList')

post_url = '/calendar/v3/calendars/openauth2@gmail.com/events'
body     = {
  "summary"=>"From OpenAuth2",
  "start"=>{"dateTime"=>"2012-01-20T10:00:00.000-07:00"},
  "end"=>{"dateTime"=>"2012-01-20T10:25:00.000-07:00"}
}
body = JSON.dump(body)

# post request
client.post(:path         => post_url,
            :body         => body,
            :content_type => content_type)

header   = {"Content-Type" => "application/json"}
full_url = "#{post_url}?access_token=#{access_token}"

# post request via #run_request
subject.run_request(:verb   => :post,
                    :path   => full_url,
                    :body   => body,
                    :header => header)
```
