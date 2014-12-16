require "generators/dresssed/handler_support"

module Dresssed
  module Generators
    class PageGenerator < Rails::Generators::NamedBase
      include HandlerSupport
      
      class_attribute :_view_name
      
      argument :action_name, :type => :string, :required => true, :banner => "ACTION",
                             :desc => "The action, also the name of the view."
      
      def create_controller
        invoke :controller, [ name ], :skip => true
      end
      
      def copy_view
        copy_file "views/#{_view_name}.html.#{handler}",
                  "app/views/#{name}/#{action_name}.html.#{handler}"
      end
      
      def self.view_name(name)
        self._view_name = name
        desc "Creates a #{name} page style view under app/views/CONTROLLER/ACTION and its controller."
        source_root File.expand_path('../templates', __FILE__)
      end
    end
  end
end

# Hides this generator. It's only used as a base class.
Rails::Generators.hide_namespace "dresssed:page"