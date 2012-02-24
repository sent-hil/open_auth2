## Authenticate Url

To start the OAuth2 exotic dance, you'll need to obtain a 'code' from the server, which you can then use to request an 'access_token'. Redirect the user/yourself to this url to obtain that 'code'.

```ruby
client.build_code_url
```

`build_code_url` takes optional params hash, which will be bundled into the url.

```ruby
client.build_code_url(:scope => 'publish_stream')
```

## AccessToken

AccessToken is used to sign the request so the server can identify the client sending the request. If you already have an access_token, add it to the client with a block.

```ruby
access_token  = 'enter in your value'
refresh_token = 'enter in your value'

client.configure do |c|
  c.access_token  = access_token

  # optional, for fb its same as above
  c.refresh_token = refresh_token
end
```

## GET Access Token

If you don't have an `access_token`, we'll need to ask the server for `access_token`, which will be used to sign our api requests.

`token#configure_connection` takes an block, just like `client#configure_connection`, which can be used to setup middleware like any other Faraday client.

```ruby
token = client.token
token.configure_connection do |c|
  c.response :logger
end

# asks Facebook api for access_token
token.get

# the following methods are now available
client.access_token
client.refresh_token
client.token_expires_at
client.token_expired?
client.token_arrived_at
```

## GET Refresh Token

```ruby
# tells Facebook api to extend the expiration of the access_token
token.refresh
```

## GET request

To make an api call, simply call `get` with a hash containing `path`.

```ruby
client.get(:path => '/cocacola')
```

`get` accepts a Hash as second argument, which can be used to pass in additional parameters.

```ruby
client.get(:path => '/cocacola', :limit => 1)
```

## POST request

## Faraday convenience methods

`Client#get` is a convenience method that calls `Faraday#get`. You can drop down to Faraday connection object itself and make requests via that also.

```ruby
client.connection.get do |conn|
  conn.url('/cocacola')
end
```

`Client#run_request` points to `Faraday#run_request`. It takes hash since I can never remember the order in which to pass the arguments.

```ruby
path = "https://graph.facebook.com/cocacola"
client.run_request(verb: :get, path: path, body: nil, header: nil)

# same as
client.connection.run_request(:get, path, nil, nil)
```

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
