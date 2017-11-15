require "generators/rrt/page_generator"

module RRT
  module Generators
    class AnalyticsDetailGenerator < PageGenerator
      view_name "analytics", "analytics_detail"

      def set_layout
        controller_const_name = "#{name.camelize}Controller".constantize
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_app_nav'\n"
      end
    end
  end
end
