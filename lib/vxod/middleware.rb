require 'sinatra/assetpack'
require 'coffee_script'
require 'omniauth'

module Vxod
  class Middleware < Sinatra::Base
    helpers do
      def vxod
        @vxod ||= Vxod.api(self)
      end
    end

    # Pages

    get Vxod.config.login_path do
      slim :login
    end

    get Vxod.config.logout_path do
      vxod.logout
    end

    get Vxod.config.fill_user_data_path do
      slim :fill_user_data, locals: { user: vxod.user_to_fill_data }
    end

    post Vxod.config.fill_user_data_path do
      unless vxod.openid_save_user_data
        slim :fill_user_data, locals: { user: vxod.user_to_fill_data }
      end
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

    get "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end

    post "#{OmniAuth.config.path_prefix}/:provider/callback" do
      vxod.login_with_openid
    end
  end
end