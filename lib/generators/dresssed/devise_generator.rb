require "generators/dresssed/handler_support"

module Dresssed
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      include HandlerSupport

      #source_root File.expand_path('../../../app/views/devise', __FILE__)

      desc "Copy Dresssed's custom Devise layouts to your project."

      def copy_layouts
        directory File.expand_path('../../../../app/views/devise', __FILE__), 'app/views/devise'
      end
    end
  end
end
