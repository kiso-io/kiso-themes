require "generators/kiso_themes/page_generator"

module KisoThemes
  module Generators
    class LandingPagesGenerator < PageGenerator
      view_name "frontend_pages/landing_pages", "landing_page"

      namespace "kiso_themes:landing_pages"

      def set_layout
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_base'\n"
      end
    end
  end
end
