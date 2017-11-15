module RRT
  class Engine < ::Rails::Engine
    initializer 'rrt.setup' do |app|
      app.config.generators.templates.unshift File.join(config.root, "lib/templates")

      # Do not generate stylesheets in code generators, this is what this theme is for.
      app.config.app_generators.stylesheets = false

      # No need to wrap in .field_with_error, fields are wrapped in .form-group.
      ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| html_tag }
    end

    initializer 'rrt.sass',
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
          'modernizr/modernizr.2.8.3.min.js',

          'gmaps/gmaps.js',
          'flot/flot-chart',
          'flot/flot-chart-resize',
          'flot/flot-chart-time',
          'flot/flot-chart-stack',

          'rickshaw/d3',
          'rickshaw/rickshaw',

          'chartjs/Chart.bundle.min',
          'chartjs/Chart.min',

          'morris/raphael',
          'morris/morris.min'
        ]
    end

    initializer 'rrt.will_paginate', :after => 'will_paginate' do
      ActiveSupport.on_load :action_view do
        if defined?(WillPaginate)
          require "rrt/extensions/will_paginate"
        end
      end
    end

    initializer 'rrt.simple_form' do
      ActiveSupport.on_load :action_view do
        simple_form_disabled = ENV['DRESSSED_SIMPLE_FORM_DISABLED']
        if defined?(SimpleForm) && !simple_form_disabled
          require "rrt/extensions/simple_form"
        else
          if simple_form_disabled
            puts "[RRT]  Bypassing simple_form initializer"
          end
        end
      end
    end
  end
end
