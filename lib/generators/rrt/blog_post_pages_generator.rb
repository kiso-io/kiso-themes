require "generators/rrt/page_generator"

module RRT
  module Generators
    class BlogPostPagesGenerator < PageGenerator
      view_name "frontend_pages/blog_pages", "blog_post"

      namespace "rrt:blog_post_pages"

      def set_layout
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_base'\n"
      end
    end
  end
end
