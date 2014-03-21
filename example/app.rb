require 'sinatra'
require 'vxod'
require 'slim'

helpers do
  def vxod 
    @vxod = Vxod.new_instance(self)
  end
end


get '/' do
  'Hello please try protected page at <a href="/secret">/secret</a>'
end

get '/secret' do
  vxod.authorize
  'I am secret page'
end