require "generators/kiso_themes/handler_support"
require_relative "../../../support/page_rewriter"

module KisoThemes
  module Generators
    class CustomizeGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../', __FILE__)

      namespace "kiso_themes:customize"

      desc "Installs required files to fully customize your KisoThemes theme."

      class_option :theme_name, :type => :string, required: true, :description => "The name of the theme you wish to generate a customize stylesheet for"
      class_option :style_name, :type => :string, required: true, :description => "The name of the theme style you wish to generate a customize stylesheet for"

      def copy_stylesheet
        unless File.directory?(File.expand_path("../../../../lib/generators/kiso_themes/templates/customizations/styles/#{options.theme_name}", __FILE__))
          raise Thor::Error, "You asked to customize theme '#{options.theme_name}', but it doesn't exist."
          return
        end

        unless File.exists?(File.expand_path("../../../../lib/generators/kiso_themes/templates/customizations/styles/#{options.theme_name}/#{options.style_name}.css.scss", __FILE__))
          raise Thor::Error, "You asked to customize theme #{options.theme_name}'s '#{options.style_name}.css.scss', but it doesn't exist."
          return
        end

        copy_file "lib/generators/kiso_themes/templates/customizations/styles/#{options.theme_name}/#{options.style_name}.css.scss", "app/assets/stylesheets/kiso_themes.css.scss"
        copy_file "lib/sass/kiso_themes/#{options.theme_name}/styles/_#{options.style_name}_variables.scss", "app/assets/stylesheets/_#{options.style_name}_variables.scss"
        copy_file "app/assets/javascripts/kiso_themes.js", "app/assets/javascripts/kiso_themes.js"

        PageRewriter.compile("app/assets/stylesheets/kiso_themes.css.scss", /kiso_themes\/#{options.theme_name}\/styles\//, '')
      end

      def add_gem

      end

      def run_bundle
        command = "install"
        say_status :run, "bundle #{command}"
        print `"#{Gem.ruby}" "#{Gem.bin_path('bundler', 'bundle')}" #{command}`
      end

      def show_readme
        readme "lib/generators/kiso_themes/templates/README_CUSTOMIZE" if behavior == :invoke
      end
    end
  end
end

# Hides this generator under Windows.
Rails::Generators.hide_namespace "kiso_themes:customize" if RUBY_PLATFORM =~ /mswin|mingw/
