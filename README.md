# Vxod

Social and password authorization solution

[![Build Status](https://travis-ci.org/SergXIIIth/vxod.svg?branch=master)](https://travis-ci.org/SergXIIIth/vxod)
[![Code Climate](https://codeclimate.com/github/SergXIIIth/vxod.png)](https://codeclimate.com/github/SergXIIIth/vxod)
[![Dependency Status](https://gemnasium.com/SergXIIIth/vxod.svg)](https://gemnasium.com/SergXIIIth/vxod)
[![Gem Version](https://badge.fury.io/rb/vxod.png)](http://badge.fury.io/rb/vxod)

[![Login](https://pbs.twimg.com/media/Bj1RKFdCUAArOZ0.png:large)](http://makridenkov.com)

# Features

- [x] openid registration/login
- [x] require email in openid registration
- [x] password base registration/login
- [x] checkbox auto-generate password and send to email
- [ ] reset password

Future

- [ ] profile with password reset, link other openid servises to user
- [ ] adminka for user management
- [ ] support Sinatra, Mongoid, Rails, ActiveRecord, any Rack app, any DB

# Simple usage

### Gemfile

``` ruby
  gem 'omniauth'
  gem 'omniauth-twitter'
  gem 'omniauth-vkontakte'
  gem 'omniauth-facebook'
  gem 'omniauth-google-oauth2'
  gem 'omniauth-github'
  gem 'vxod'
```

### app.rb

``` ruby
  enable :sessions
  set :sessions, secret: ENV['secret_secret']

  use OmniAuth::Builder do
    provider :twitter, ENV['omniauth.twitter'], ENV['omniauth.twitter_x']
    provider :vkontakte, ENV['omniauth.vkontakte'], ENV['omniauth.vkontakte_x']
    provider :facebook, ENV['omniauth.facebook'], ENV['omniauth.facebook_x']
    provider :google_oauth2, ENV['omniauth.google'], ENV['omniauth.google_x']
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  end

  use Vxod::Middleware

  # render middware html in app layout
  %w(get post).each do |method|
    app.send(method, '*') do
      if env['VXOD.HTML']
        slim :vxod_layout, locals: { html: env['VXOD.HTML'] }
      else
        pass
      end
    end
  end
```

### config/smtp.rb

``` ruby
Pony.options = {
  from: '???',
  via: :smtp,
  via_options: {
    address:      'smtp.yandex.ru',
    port:         '587',
    smtp_domain:  '???',
    user_name:    '???',
    password:     '???',

    enable_starttls_auto: true,
    authentication: :plain, # :plain, :login, :cram_md5, no auth by default
  }
}
```


# API

Vxod.config
Vxod.api(rack_app)

# Installation

- gem 'vxod'
- configure email
- provide key for open auth
- provide layout to inject views

## Config OmniAuth

Gems

    gem 'omniauth'
    gem 'omniauth-twitter'
    gem 'omniauth-vkontakte'
    gem 'omniauth-facebook'
    gem 'omniauth-google_oauth2'
    gem 'omniauth-github'

App

    enable :sessions
    set :sessions, secret: ENV['secret_secret']

    use OmniAuth::Builder do
      provider :twitter, ENV['omniauth.twitter'], ENV['omniauth.twitter_x']
      provider :vkontakte, ENV['omniauth.vkontakte'], ENV['omniauth.vkontakte_x']
      provider :facebook, ENV['omniauth.facebook'], ENV['omniauth.facebook_x']
      provider :google_oauth2, ENV['omniauth.google'], ENV['omniauth.google_x']
      provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    end

    use Vxod::Middleware # put it after use OmniAuth

## Config SMTP, example on yander.ru




# Usage

TODO: Write usage instructions here

# Contributing

1. Fork it ( http://github.com/SergXIIIth/vxod/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
