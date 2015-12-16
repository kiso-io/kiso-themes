require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class BlogPostGenerator < PageGenerator
      view_name "blog_post"

      def set_layout
        inject_into_class "app/controllers/#{name.underscore}_controller.rb", "#{name.camelize}Controller".constantize, "  layout '_minimal'\n"
      end
    end
  end
end
