require "generators/dresssed/handler_support"

module Dresssed
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      include HandlerSupport

      desc "Copy Dresssed's custom Devise layouts to your project."

      def copy_layouts
        directory File.expand_path("../../../../app/views/devise/#{handler}", __FILE__), 'app/views/devise'
      end
    end
  end
end
