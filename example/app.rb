require 'sinatra'
require 'vxod'
require 'slim'
require 'config_env'
require 'mongoid'
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-vkontakte'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require 'omniauth-github'

require_relative 'config_env'
require_relative 'config_app'

helpers do
  def vxod 
    @vxod = Vxod.api(self)
  end
end

get '/' do
  'Hello please try protected page at <a href="/secret">/secret</a>'
end

get '/secret' do
  vxod.required
  'I am secret page'
end