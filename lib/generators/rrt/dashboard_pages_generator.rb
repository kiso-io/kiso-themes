require "generators/rrt/page_generator"
require_relative "../../../support/page_rewriter"

module RRT
  module Generators
    class DashboardPagesGenerator < PageGenerator
      view_name "dashboards","dashboard"

      namespace "rrt:dashboard_pages"

      def set_layout
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout 'sidenav'\n"
      end

      def copy_partials
        source_view_path="views/#{_view_type}/"
        partials = Dir.glob(File.expand_path("../templates/views/#{_view_type}/*", __FILE__)).select{ |lf| File.basename(lf).start_with?("_") && lf.end_with?(handler) }.map { |lf| File.basename(lf, ".html.#{handler}")}

        partials.each do |partial|
          destination = "app/views/#{name.underscore}/#{partial}.html.#{handler}"
          copy_file "views/#{_view_type}/#{partial}.html.#{handler}", destination
        end

        controller_const_name = "#{name.camelize}Controller"
        for action in actions do
          PageRewriter.compile("app/views/#{name.underscore}/#{action}.html.#{handler}", /dashboards/, "#{name.underscore}")
          inject_into_file "app/controllers/#{file_name}_controller.rb", after: "def #{action}"  do
  <<-RUBY
          \n    @body_class = "with-sidebar show-sidebar"
  RUBY
          end
        end
      end
    end
  end
end
