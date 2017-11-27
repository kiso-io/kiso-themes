require "generators/rrt/handler_support"
require_relative "../../../support/page_rewriter"

module RRT
  module Generators
    class CustomizeGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../', __FILE__)

      namespace "rrt:customize"

      desc "Installs required files to fully customize your RRT theme."

      class_option :theme_name, :type => :string, required: true, :description => "The name of the theme you wish to generate a customize stylesheet for"
      class_option :style_name, :type => :string, required: true, :description => "The name of the theme style you wish to generate a customize stylesheet for"

      def copy_stylesheet
        copy_file "test/dummy/app/assets/stylesheets/styles/#{options.theme_name}/#{options.style_name}.css.scss", "app/assets/stylesheets/rrt.css.scss"
        copy_file "lib/sass/rrt/#{options.theme_name}/styles/_#{options.style_name}_variables.scss", "app/assets/stylesheets/_#{options.style_name}_variables.scss"
        copy_file "app/assets/javascripts/rrt.js", "app/assets/javascripts/rrt.js"

        PageRewriter.compile("app/assets/stylesheets/rrt.css.scss", /rrt\/#{options.theme_name}\/styles\//, '')
      end

      def add_gem

      end

      def run_bundle
        command = "install"
        say_status :run, "bundle #{command}"
        print `"#{Gem.ruby}" -rubygems "#{Gem.bin_path('bundler', 'bundle')}" #{command}`
      end

      def show_readme
        readme "lib/generators/rrt/templates/README_CUSTOMIZE" if behavior == :invoke
      end
    end
  end
end

# Hides this generator under Windows.
Rails::Generators.hide_namespace "rrt:customize" if RUBY_PLATFORM =~ /mswin|mingw/
