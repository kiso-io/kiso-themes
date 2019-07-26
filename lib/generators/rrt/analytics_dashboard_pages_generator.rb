require "generators/rrt/page_generator"

module RRT
  module Generators
    class AnalyticsDashboardPagesGenerator < PageGenerator
      view_name "analytics", "analytics_dashboard"

      namespace "rrt:analytics_dashboard_pages"

      def set_layout
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_app_nav'\n"
      end
    end
  end
end
