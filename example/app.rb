require 'sinatra'
require 'vxod'
require 'slim'
require 'sass'
require 'config_env'
require 'mongoid'
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-vkontakte'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require 'omniauth-github'

load "#{__dir__}/config_env"
require_relative 'config_app'

helpers do
  def vxod 
    @vxod = Vxod.api(self)
  end
end

get '/' do
  'Hello please try protected page at <a id="secret" href="/secret">/secret</a>'
end

get '/secret' do
  vxod.required
  slim :secret
end

template :secret do
%q(

p 
  | I am secret page for 
  strong = vxod.user.email
p: a id='logout' href='/logout' Logout

)
end