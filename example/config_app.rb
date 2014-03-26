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

# OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
#   :provider => 'vkontakte',
#   :uid => '123545'
# })

# Db

require 'vxod/db/mongoid'

Vxod::Db.identity = Vxod::Db::Mongoid::Identity
Vxod::Db.user = Vxod::Db::Mongoid::User