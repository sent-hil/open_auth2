# open_auth2 [![Build Status](https://secure.travis-ci.org/sent-hil/open_auth2.png?branch=master)][travis]

[travis]: http://travis-ci.org/sent-hil/open_auth2

OpenAuth2 is a thin OAuth2 wrapper written on top of Faraday in Ruby. The goal is a simple, well documented, easy to use interface for all your OAuth2 needs.

* This software is alpha, you're either very brave or very foolish to use this in production of rockets or anything else.

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
  # Accepts: OpenAuth2::Provider::Default, OpenAuth2::Provider::Facebook, OpenAuth2::Provider::Google

  c.provider       = OpenAuth2::Provider::Facebook

  c.client_id      = client_id
  c.client_secret  = client_secret
  c.redirect_uri   = redirect_uri
  c.scope          = ['publish_stream']
end
```

## Client

Next, initialize a `client` object, which we'll use to make requests and pass in the `config` object we created earlier.

```ruby
client = OpenAuth2::Client.new(config)
```

`Client#connection` returns a `Faraday::Connection` object, which can be used to setup middleware.

```ruby
client.connection do
  response :logger
end
```

## Authenticate Url

To start the OAuth2 exotic dance, you'll need to obtain a 'code' from the server, which you can then use to request an 'access_token'. Redirect the user/yourself to this url to obtain that 'code'.

```ruby
token.build_code_url
```

`build_code_url` takes optional params hash, which will be bundled into the url.

```ruby
token.build_code_url(:scope => 'publish_stream')
```

## Access token

Access token is used to sign the request so the server can identify the client sending the request. If you already have an access token, add it to the client with a block.

```ruby
client.access_token  = 'enter in your value'
client.refresh_token = 'enter in your value'
```

## GET Access Token

If you don't have an access token, we'll need to ask the server for it.

`token#configure` is similar to `client#connection`.

```ruby
token = OpenAuth2::Token.new(config)

# asks Facebook for access_token
token.get

# the following methods are now available
token.access_token
token.refresh_token
token.token_expires_at
token.token_expired?
token.token_arrived_at
```

## GET Refresh Token

```ruby
# tells Facebook api to extend the expiration of the access_token
token.refresh
```

## GET request

To make an api call, simply call `get` with your path.

```ruby
client.get('/cocacola')
```

`get` accepts a Hash as second argument, which can be used to pass in additional parameters.

```ruby
client.get('/cocacola', :limit => 1)
```

## Faraday convenience methods

`Client#get` is a convenience method that calls `Faraday#get`. You can drop down to Faraday connection object itself and make requests via that also.

```ruby
client.connection.get do |conn|
  conn.url('/cocacola')
end
```

## Plugins

Since various OAuth2 providers differ in their implementation, OpenAuth2 provides a simple plugin system to accomodate the differences, rather than 'one shoe fits all' approach. Facebook and Google plugins are builtin, but it is trivial to add new ones.

There are only four requirements:

  1. Should be under right namespace (OpenAuth2::Provider)
  1. Can contain #options method

To use the plugin, call `Config#provider=` with name of the provider.

### Plugin Example

```ruby
module OpenAuth2
  module Provider

    # Provider::Base contains keys of various accepted Options,
    # while Provider::Default contains the default options and
    # their values. You can however override them here.
    #
    class ThirdApi
      def options
        {
          :response_type            => 'code',
          :access_token_grant_name  => 'authorization_code',
          :refresh_token_grant_name => 'refresh_token',
          :refresh_token_name       => :refresh_token,
          :scope                    => [],
        }
      end

      # parse token body, set it to vars in config
      def parse(token_body)
        token = response_body.gsub('access_token=', '')
        config.access_token = token
      end
    end
  end
end
```

## Examples

See examples/ for more ... (its a surprise).

## Requirements

  * ActiveSupport
  * Faraday
  * URI
  * Json

## Supported Versions

  * MRI 1.9.2
  * MRI 1.9.3
  * jRuby (jruby --1.9 rspec)
  * Rubinius 2.0.0dev (RBXOPT=-X19 rbx- S rspec)

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

See [meta](https://github.com/senthilnambi/meta) for more info on contributing and technology used to create this gem.

## Copyright

(The MIT License)

Copyright (c) 2012, sent-hil <me@sent-hil.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software isfurnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
