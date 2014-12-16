module Dresssed
  module Ives
    class Engine < ::Rails::Engine
      initializer 'dresssed.setup' do |app|
        app.config.generators.templates << File.join(config.root, "lib/templates")

        # Do not generate stylesheets in code generators, this is what this theme is for.
        app.config.app_generators.stylesheets = false

        # No need to wrap in .field_with_error, fields are wrapped in .form-group.
        ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| html_tag }
      end

      initializer 'dresssed.sass',
                  :after => 'sass_rails',
                  :group => :all do |app|

          app.config.sass.load_paths << File.join(config.root, "lib", "sass")
          app.config.assets.paths << File.join(config.root, "lib", "sass")
          app.config.assets.paths << File.join(config.root, 'app', 'assets', 'fonts')

          app.config.assets.precompile.push(Proc.new do |path|
            File.extname(path).in? [
              '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
              '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
            ]
          end)
      end

      initializer 'dresssed.compressor',
                  :after => :setup_compression,
                  :group => :all do |app|
        # FIX: Sass CssCompressor can't handle the current version of Bootstrap.
        #      Because of IE9 fix "\0/" used in forms.less.
        if app.config.assets.css_compressor.class.name == "Sass::Rails::CssCompressor"
          app.config.assets.css_compressor = nil
        end
      end

      initializer 'dresssed.will_paginate', :after => 'will_paginate' do
        ActiveSupport.on_load :action_view do
          if defined?(WillPaginate)
            require "dresssed/extensions/will_paginate"
          end
        end
      end

      initializer 'dresssed.simple_form' do
        ActiveSupport.on_load :action_view do
          if defined?(SimpleForm)
            require "dresssed/extensions/simple_form"
          end
        end
      end
    end
  end
end
