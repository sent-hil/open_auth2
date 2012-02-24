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
