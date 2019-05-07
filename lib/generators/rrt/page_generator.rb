require "generators/rrt/handler_support"

module RRT
  module Generators
    class PageGenerator < Rails::Generators::NamedBase
      include HandlerSupport

      remove_hook_for :helper
      class_attribute :_view_name, instance_writer: false
      class_attribute :_view_type, instance_writer: false

      argument :actions, type: :array, required: true, banner: "ACTION", desc: "The action, also the name of the view."
      class_option :variant, :type => :string, :default => 1, :description => "The template variant (i.e. 1, 2 etc)"

      hide!

      def create_controller
        invoke :controller, [name, actions], skip: false, skip_routes: false, helper: false, test_framework: false, assets: false, template_engine: false
        Rails.autoloaders.main.reload
      end

      def copy_view
        for action in actions do
          view_name = action
          copy_file "views/#{_view_type}/#{_view_name}_#{options.variant}.html.#{handler}", "app/views/#{name.downcase.underscore}/#{action}.html.#{handler}"
        end
      end

      def self.view_name(type, name)
        self._view_name = name
        self._view_type = type
        desc "Creates a #{name} page style view under app/views/CONTROLLER/ACTION and its controller."
        source_root File.expand_path('../templates', __FILE__)
      end
    end
  end
end
