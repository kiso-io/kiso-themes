require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class HomeGenerator < PageGenerator
      view_name "home"

      def set_layout
        inject_into_class "app/controllers/#{name}_controller.rb", "#{name.titleize}Controller".constantize, "  layout 'home'\n"
      end
    end
  end
end
