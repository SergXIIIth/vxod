require 'sinatra/assetpack'

class Vxod::Middleware < Sinatra::Base
  get '/login' do
    slim :login
  end

  # assets

  register Sinatra::AssetPack

  assets do
    serve '/vxod/js',  from: 'assets/js'    
    serve '/vxod/css', from: 'assets/css'   
    serve '/vxod/img', from: 'assets/img'   

    js :app, [
      '/vxod/js/jquery.js',
      '/vxod/js/**/*.js',
      '/vxod/js/**/*.coffee',
    ]

    css :app, [
      '/vxod/css/*.css',
      '/vxod/css/*.sass'
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish
  end  
end