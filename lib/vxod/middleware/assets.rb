require 'sinatra/assetpack'
require 'coffee_script'

class Vxod::Middleware
  module Assets
    def self.registered(app)
      app.register Sinatra::AssetPack

      app.assets do
        serve '/vxod/js',  from: 'middleware/assets/js'
        serve '/vxod/css', from: 'middleware/assets/css'
        serve '/vxod/img', from: 'middleware/assets/img'

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
  end
end
