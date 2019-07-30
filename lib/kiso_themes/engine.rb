# require kaminari early so we can override it's views
if Gem::Specification::find_all_by_name('kaminari').any?
  require 'kaminari'
end

if Gem::Specification::find_all_by_name('sass-rails').any?
  require 'sass-rails'
end

module KisoThemes
  class Engine < ::Rails::Engine
    
    initializer 'kiso_themes.setup' do |app|
      app.config.generators.templates.unshift File.join(config.root, "lib/templates")

      # Do not generate stylesheets in code generators, this is what this theme is for.
      app.config.app_generators.stylesheets = false

      # No need to wrap in .field_with_error, fields are wrapped in .form-group.
      ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| html_tag }
    end

    initializer 'kiso_themes.sass',
                :after => 'sass_rails',
                :group => :all do |app|

        app.config.sass.load_paths << File.join(config.root, "lib", "sass")
        app.config.assets.paths << File.join(config.root, "lib", "sass")
        app.config.assets.paths << File.join(config.root, 'app', 'assets', 'fonts')

        types = [
          '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
          '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
        ]

        if Gem::Version.new(::Rails.version) >= Gem::Version.new("5.1.0.rc1")
					Dir.glob(config.root.join('app/assets/*/**/**')) do |assets_directory|
						app.config.assets.precompile += [assets_directory] if File.extname(assets_directory).in? types
					end
				else
					app.config.assets.precompile.push(Proc.new do |path|
						File.extname(path).in? types
					end)
        end

        app.config.assets.precompile += [
          'vendor/modernizr/modernizr.2.8.3.min.js',

          'vendor/gmaps/gmaps.js',
          'vendor/flot/flot-chart',
          'vendor/flot/flot-chart-resize',
          'vendor/flot/flot-chart-time',
          'vendor/flot/flot-chart-stack',

          'vendor/rickshaw/d3',
          'vendor/rickshaw/rickshaw',

          'vendor/chartjs/Chart.bundle.min',
          'vendor/chartjs/Chart.min',

          'vendor/morris/raphael',
          'vendor/morris/morris.min'
        ]
    end

    initializer 'kiso_themes.will_paginate', :after => 'will_paginate' do
      ActiveSupport.on_load :action_view do
        if defined?(WillPaginate)
          require "kiso_themes/extensions/will_paginate"
        end
      end
    end

    initializer 'kiso_themes.simple_form' do
      ActiveSupport.on_load :action_view do
        simple_form_disabled = ENV['KISOTHEMES_SIMPLE_FORM_DISABLED']
        if defined?(SimpleForm) && !simple_form_disabled
          require "kiso_themes/extensions/simple_form"
        else
          if simple_form_disabled
            puts "[KisoThemes]  Bypassing simple_form initializer"
          end
        end
      end
    end
  end
end
