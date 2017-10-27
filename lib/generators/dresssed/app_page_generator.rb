require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class AppPageGenerator < Rails::Generators::NamedBase
      include HandlerSupport

      remove_hook_for :helper
      class_attribute :_page_type
      source_root File.expand_path('../templates', __FILE__)
      hide!

      def create_controller
        invoke :controller, [name], skip: false, skip_routes: true, helper: false, test_framework: false, assets: false, template_engine: false
      end

      def copy_view
        directory( "views/app_pages/#{_page_type}", "app/views/#{name.underscore}/", { recursive: true, exclude_pattern: /\.(#{unsupported_handlers.join('|')})/ } )
      end

      def set_layout
        controller_const_name = "#{name.camelize}Controller".constantize
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  layout 'application'\n"
      end

      def self.page_type(page_type)
        self._page_type = page_type
        source_root File.expand_path('../templates', __FILE__)
      end
    end
  end
end

