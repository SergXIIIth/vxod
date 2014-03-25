require 'sinatra/assetpack'
require 'coffee_script'

class Vxod::Middleware < Sinatra::Base
  enable :sessions
  set :sessions, secret: Vxod.config.secret_secret

  get Vxod.config.login_path do
    slim :login
  end

  # Assets

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

  # OpenId

end