require 'sinatra'
require 'vxod'
require 'slim'

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