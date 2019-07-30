require "generators/kiso_themes/page_generator"

module KisoThemes
  module Generators
    class FaqPagesGenerator < PageGenerator
      desc "Installs the Rapid Rails Themes faq page into the your chosen directory."

      namespace "kiso_themes:faq_pages"
      view_name "frontend_pages/faq_pages","faq_page"

      def set_layout
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_base'\n"
      end
    end
  end
end
