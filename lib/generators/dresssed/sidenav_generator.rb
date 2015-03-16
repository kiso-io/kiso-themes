require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class SidenavGenerator < PageGenerator
      view_name "sidenav"

      def set_layout
        inject_into_class "app/controllers/#{name}_controller.rb", "#{name.titleize}Controller".constantize, "  layout 'sidenav'\n"
      end
    end
  end
end
