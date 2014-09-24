require 'sinatra'
require 'vxod'
require 'slim'
require 'sass'
require 'config_env'
require 'mongoid'
require 'omniauth'
require 'omniauth-vkontakte'
require_relative 'config'

helpers do
  def vxod
    @vxod = Vxod.api(self)
  end
end

class SetLocale
  def initialize(app)
    @app = app
  end

  def call(env)
    I18n.locale = :ru
    @app.call(env)
  end
end

use SetLocale

enable :sessions
set :sessions, secret: ENV['secret_secret']

use OmniAuth::Builder do
  provider :vkontakte, ENV['omniauth.vkontakte'], ENV['omniauth.vkontakte_x']
end

use Vxod::Middleware

get '/' do
  'Hello please try protected page at <a id="secret" href="/secret">/secret</a>'
end

get '/secret' do
  vxod.required
  slim :secret
end

# render middware html in app layout
%w(get post).each do |method|
  self.send(method, '*') do
    if env['VXOD.HTML']
      env['VXOD.HTML']
    else
      pass
    end
  end
end


template :secret do
%q(

p
  | I am secret page for
  strong< = vxod.user.email
p: a id='logout' href='/logout' Logout

)
end
