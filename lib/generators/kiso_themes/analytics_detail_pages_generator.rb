require "generators/kiso_themes/page_generator"

module KisoThemes
  module Generators
    class AnalyticsDetailPagesGenerator < PageGenerator
      view_name "analytics", "analytics_detail"

      namespace "kiso_themes:analytics_detail_pages"

      def set_layout
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_app_nav'\n"
      end
    end
  end
end
