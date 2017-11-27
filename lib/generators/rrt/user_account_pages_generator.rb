
require "generators/rrt/app_page_generator"

module RRT
  module Generators
    class UserAccountPagesGenerator < AppPageGenerator
      desc "Installs the User pages under the /user route"

      namespace "rrt:user_account_pages"

      page_type('user_account')

      def setup_routing
        route "get '/user' => '#{name}#profile'"
        route "get '/user/billing' => '#{name}#billing'"
        route "get '/user/plan' => '#{name}#plan'"
        route "get '/user/profile' => '#{name}#profile'"
        route "get '/user/support' => '#{name}#support'"
        route "get '/user/notifications' => '#{name}#notifications'"
      end

      def create_controller_methods
        controller_const_name = "#{name.camelize}Controller".constantize
        target_controller_file_name = File.join('app/controllers', class_path, "#{file_name}_controller.rb")

        ["index", "billing", "plan", "profile", "support", "notificaitons"].each do |method_name|
          inject_into_file( target_controller_file_name, build_method(method_name), before: /^end/ )
        end
      end

      def set_partial_path
        controller_const_name = "#{name.camelize}Controller".constantize
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  prepend_view_path(File.join(Rails.root, 'app/views/#{name}/'))\n"
      end

      protected

        def build_method( name )
        code = <<END
  def #{name}
  end

END
        end
    end
  end
end
