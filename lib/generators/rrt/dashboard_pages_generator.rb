require "generators/rrt/page_generator"

module RRT
  module Generators
    class DashboardPagesGenerator < PageGenerator
      view_name "dashboards","dashboard"

      namespace "rrt:dashboard_pages"

      def set_layout
        controller_const_name = "#{name.camelize}Controller".constantize
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout 'sidenav'\n"
      end

      def set_body_class_for_sidenav
        controller_const_name = "#{name.camelize}Controller".constantize
        inject_into_file "app/controllers/#{file_name}_controller.rb", after: "def index"  do
<<-RUBY
        \n    @body_class = "show-sidebar"
RUBY
        end
      end
    end
  end
end
