# Mongoid

Mongoid.load!(__dir__ + '/mongoid.yml')


# OmniAuth

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


# Db

require 'vxod/db/mongoid'

Vxod::Db.openid = Vxod::Db::Mongoid::Openid
Vxod::Db.user = Vxod::Db::Mongoid::User

# Emails


if %w(development production).includes?(ENV['RACK_ENV'])
  Pony.options = {
    from: 'Makridenkov <hello@makridenkov.com>', 
    via: :smtp, 
    via_options: { 
      address:      'smtp.yandex.ru',
      port:         '587',
      smtp_domain:  'makridenkov.com',
      user_name:    ENV['smtp.user'],
      password:     ENV['smtp.password'],

      enable_starttls_auto: true,
      authentication: :plain
    } 
  }
end