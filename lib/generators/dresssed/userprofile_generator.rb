require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class UserprofileGenerator < PageGenerator
      view_name "user_profile"

      def set_layout
        inject_into_class "app/controllers/#{name.underscore}_controller.rb", "#{name.camelize}Controller".constantize, "  layout 'application'\n"
      end
    end
  end
end
