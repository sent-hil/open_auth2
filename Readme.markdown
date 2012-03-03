# OpenAuth2 [![Build Status](https://secure.travis-ci.org/senthilnambi/OpenAuth2.png?branch=master)][travis]

[travis]: http://travis-ci.org/senthilnambi/OpenAuth2

OpenAuth2 is a thin OAuth2 wrapper written on top of Faraday in Ruby. The goal is a simple, well documented, easy to use interface for all your OAuth2 needs.

* This software is alpha, you're either very brave or very foolish to use this in production of rockets or anything else.
* This Readme is best viewed in [DocumentUp](http://documentup.com/senthilnambi/OpenAuth2).

## Config

To begin, let's setup the configuration. Here we're assuming connection to Facebook api. OpenAuth2 supports Google and Facebook out of the box (more to come soon). Other sites can be configured manually.

```ruby
require 'open_auth2'

# get this info by signing your app at developers.facebook.com
client_id     = 'enter in your own value'
client_secret = 'enter in your own value'
redirect_uri  = 'enter in your own value'

config = OpenAuth2::Config.new do |c|
  # indicate what kind of provider you want to use
  # Accepts: :google, :facebook or :default
  #
  c.provider       = :facebook

  c.client_id      = client_id
  c.client_secret  = client_secret
  c.redirect_uri   = redirect_uri
  c.scope          = ['publish_stream']
end
```

## Client

Next, initialize a `client` object, which we'll use to make requests and pass in the `config` object we created earlier.

```ruby
client = OpenAuth2::Client.new do |c|
  c.config = config
end
```

`Client#configure_connection` takes a block, which can be used to setup middleware like any other Faraday client, i.e:

```ruby
client.configure_connection do |c|
  c.response :logger
end
```

## Authenticate Url

To start the OAuth2 exotic dance, you'll need to obtain a 'code' from the server, which you can then use to request an 'access_token'. Redirect the user/yourself to this url to obtain that 'code'.

```ruby
client.build_code_url
```

`build_code_url` takes optional params hash, which will be bundled into the url.

```ruby
client.build_code_url(:scope => 'publish_stream')
```

## Access token

Access token is used to sign the request so the server can identify the client sending the request. If you already have an access token, add it to the client with a block.

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

If you don't have an access token, we'll need to ask the server for it.

`token#configure_connection` takes an block, just like `client#configure_connection`, which can be used to setup middleware like any other Faraday client.

```ruby
token = client.token
token.configure_connection do |c|
  c.response :logger
end

# asks Facebook for access_token
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
  "summary" => "From OpenAuth2",
  "start"   => {"dateTime"=>"2012-01-20T10:00:00.000-07:00"},
  "end"     => {"dateTime"=>"2012-01-20T10:25:00.000-07:00"}
}
body = JSON.dump(body)

# post request
client.post(:path         => post_url,
            :body         => body,
            :content_type => content_type)

header   = {"Content-Type" => "application/json"}
full_url = "#{post_url}?access_token=#{access_token}"

# post request via #run_request
client.run_request(:verb   => :post,
                   :path   => full_url,
                   :body   => body,
                   :header => header)
```

## Requirements

  * ActiveSupport
  * Faraday
  * URI
  * Json

## Install

    $ gem install open_auth2

## Source

OpenAuth2's git repo is available on GitHub:

    https://github.com/senthilnambi/OpenAuth2

## Development

You will need these gems to get tests to pass:

  * rspec2
  * rake
  * SimpleCov (optional for coverage)

## Contributing

If you'd like to hack on OpenAuth2, follow these instructions. To get all of the dependencies, install the gem first.

  1. Fork the project to your own account
  1. Clone down your fork
  1. Create a thoughtfully named topic branch to contain your change
  1. Hack away
  1. Add tests and make sure everything still passes by running `rake`
  1. If you are adding new functionality, document it in README.md
  1. Do not change the version number, I will do that on my end
  1. If necessary, rebase your commits into logical chunks, without errors
  1. Push the branch up to GitHub
  1. Send a pull request for your branch

## Technology

This library was developed on a Macbook Pro. Software/methodology include:

  * iTerm2 ([link][1])
  * zsh ([zshrc][2])
  * MacVim ([.vimrc][3]/[.gvimrc][4])
  * ruby-1.9.3
  * git
  * rspec2
  * Readme driven development (see Spec for an ideal api, Readme for currently implemented )
  * Behavior driven development

[1]: http://www.iterm2.com/#/section/home
[2]: https://github.com/senthilnambi/dotfiles/blob/master/dotfiles/.zshrc
[3]: https://github.com/senthilnambi/dotfiles/blob/master/dotfiles/.vimrc
[4]: https://github.com/senthilnambi/dotfiles/blob/master/dotfiles/.gvimrc

## Copyright

Copyright (c) 2012 Senthil A. See License for details.
