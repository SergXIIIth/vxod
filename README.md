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
