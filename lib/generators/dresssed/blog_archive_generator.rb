require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class BlogArchiveGenerator < PageGenerator
      view_name "frontend_pages/blog_pages", "blog_archive"

      def set_layout
        controller_const_name = "#{name.camelize}Controller".constantize
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout '_base'\n"
      end
    end
  end
end
