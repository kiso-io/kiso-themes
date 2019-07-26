
require "generators/rrt/app_pages_generator"

module RRT
  module Generators
    class UserAccountPagesGenerator < AppPagesGenerator
      desc "Installs the User pages under the /user route"

      namespace "rrt:user_account_pages"

      set_page_type('user_account')

      def setup_routing
        route "get '/user' => '#{name.downcase}#profile'"
        route "get '/user/billing' => '#{name.downcase}#billing'"
        route "get '/user/plan' => '#{name.downcase}#plan'"
        route "get '/user/profile' => '#{name.downcase}#profile'"
        route "get '/user/support' => '#{name.downcase}#support'"
        route "get '/user/notifications' => '#{name.downcase}#notifications'"
      end

      def create_controller_methods
        controller_const_name = "#{name.camelize}Controller"
        target_controller_file_name = File.join('app/controllers', class_path, "#{file_name}_controller.rb")

        ["index", "billing", "plan", "profile", "support", "notifications"].each do |method_name|
          inject_into_file( target_controller_file_name, build_method(method_name), before: /^end/ )
        end
      end

      def set_partial_path
        controller_const_name = "#{name.camelize}Controller"
        inject_into_class File.join('app/controllers', class_path, "#{file_name}_controller.rb"), controller_const_name, "  prepend_view_path(File.join(Rails.root, 'app/views/#{name.downcase}/'))\n"
      end

      protected

        def build_method( name )
        code = <<END
  def #{name.downcase}
  end

END
        end
    end
  end
end
