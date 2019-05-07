require "generators/rrt/handler_support"

module RRT
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include HandlerSupport

      source_root File.expand_path('../templates', __FILE__)

      namespace "rrt:install"

      desc "Installs the RRT theme in your application."

      def copy_layouts
        layouts_path = "app/views/layouts"
        layouts = Dir.glob(File.expand_path("../templates/layouts/*", __FILE__)).select{ |lf| lf.end_with?(handler) }.map { |lf| File.basename(lf, ".html.#{handler}")}

        layouts.each do |name|
          copy_file "layouts/#{name}.html.#{handler}", "#{layouts_path}/#{name}.html.#{handler}"
        end
      end

      def copy_stylesheet
        copy_file "rrt.css", "app/assets/stylesheets/rrt.css"
      end

      def add_jquery_to_gemfile
        return if rails6?
        return unless Gem::Version.new(::Rails.version) >= Gem::Version.new("5.1.0.rc1")
        say_status :info, "Adding jQuery back into the Gemfile"
        gem "jquery-rails"
        system('bundle install')
      end

      def add_jquery_require_to_app_js
        return if rails6?
        return unless Gem::Version.new(::Rails.version) >= Gem::Version.new("5.1.0.rc1")
        sentinel = "= require rails-ujs"

        file = 'app/assets/javascripts/application.js'

        # Plain JS
        if File.file?(file)
          inject_into_file file, "\n//= require jquery\n", { :before => "//#{sentinel}" }
        # CoffeeScript
        elsif File.file?("#{file}.coffee")
          inject_into_file "#{file}.coffee", "\n#require jquery\n", { :before => "##{sentinel}" }
        # No main JS file
        else
          say_status :warning, "Can't find #{file}. " +
            "Make sure to include add `require rrt` in your Javascript.", :red
        end
      end

      def require_rrt_javascript
        return if rails6?
        sentinel = "= require_tree ."
        code = "= require rrt\n\n"

        file = 'app/assets/javascripts/application.js'
        # Plain JS
        if File.file?(file)
          inject_into_file file, "\n//#{code}", { :before => "//#{sentinel}" }
        # CoffeeScript
        elsif File.file?("#{file}.coffee")
          inject_into_file "#{file}.coffee", "\n##{code}", { :before => "##{sentinel}" }
        # No main JS file
        else
          say_status :warning, "Can't find #{file}. " +
            "Make sure to include add `require rrt` in your Javascript.", :red
        end
      end

      def install_for_rails6
        return unless rails6?

        say "Configuring for Rails 6..."

        # Nothing needs to happen yet for Styles as Sprockets is still used
        # in Rails 6 for handling styles and images etc.

        vendor_libs = %w{
          webpack-merge
          jquery
          popper.js
          bootstrap@4.3.1
          bootstrap-switch
          chartjs
          clipboard
          jquery-countdown
          jquery-countto
          cd-easypiechart
          fastclick
          object-fit-images
          flot
          gmaps.core
          jasny-bootstrap
          jqvmap
          jvectormap@2.0.4
          metismenu@2.7.2
          modernizr
          parallax.js
          code-prettify
          prismjs
          jquery-slimscroll
          sparklines
        }

        # Add jquery to the package.json
        system("yarn add #{vendor_libs.join(' ')}")


        # Copy the pack index file
        directory "rails6", "app/javascript/rrt"

        # Add jQuery to application pack
        inject_into_file 'app/javascript/packs/application.js', "\n#{new_requires}\n", { before: 'require("@rails/ujs").start()'}

        # Add RRT import to application pack
        append_to_file 'app/javascript/packs/application.js', "\nrequire(\"rrt\")\n"

        # Change layout javascript_include to javascript_pack
        gsub_file "app/views/layouts/_base.html.#{handler}", "javascript_include_tag", "javascript_pack_tag"

        # Add jQuery symbols as provide plugins in Webpack
        inject_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')" do <<-JS

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    Popper: ['popper.js', 'default'], // for Bootstrap 4

    // Include Clipboard.js with a rename since it conflicts with
    // Chrome's own upcoming Clipboard API.
    ClipboardJS: 'clipboard'
  })
)
        JS
        end
      end

      def add_app_name_to_application_helper
        sentinel = "module ApplicationHelper\n"
        code = <<END
  def app_name
    Rails.application.class.module_parent_name
  end
END

        file = 'app/helpers/application_helper.rb'
        create_file file, "module ApplicationHelper\nend" unless File.file?(file)
        inject_into_file file, code, { :after => sentinel }
      end

      def copy_favicons_into_asset_pipeline
        return unless Gem::Version.new(::Rails.version) >= Gem::Version.new("5.1.0.rc1")
        copy_file Rails.root.join('public', 'favicon.ico'), Rails.root.join('app', 'assets', 'images', 'favicon.ico')
      end

      def show_readme
        readme_template "README.tt" if behavior == :invoke
      end

      protected
        def devise?
          defined?(Devise)
        end

        def rails6?
          Gem::Version.new(::Rails.version) >= Gem::Version.new("6.0.0.rc1") && Gem::Version.new(::Rails.version) < Gem::Version.new("7.0.0")
        end

        # Can't fully cutomize theme under Windows because of less.rb dep on therubyracer.
        def can_customize?
          RUBY_PLATFORM !~ /mswin|mingw/
        end

        def readme_template(file)
          source = File.binread(find_in_source_paths(file))
          log ERB.new(source, nil, '-', '@output_buffer').result(binding)
        end

        def new_requires
          <<-JS
window.$ = window.jQuery = require("jquery")
// ***** START: ADDED BY RRT *****
require("bootstrap")
require("metismenu/dist/cjs")
require("jquery-slimscroll")
require('bootstrap-switch')
require('chartjs')
require('jquery-countdown')
require('jquery-countto')
require('cd-easypiechart')
require('fastclick')
require('object-fit-images')
require('flot/source/jquery.canvaswrapper');
require('flot/source/jquery.flot');
require('gmaps.core')
require('jasny-bootstrap')
require('jvectormap')
require('parallax.js')
require('code-prettify')
require('prismjs')
require('sparklines')
// ***** END: ADDED BY RRT *****
          JS
        end
    end
  end
end
