require "generators/rrt/handler_support"

module RRT
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      include HandlerSupport

      source_root File.expand_path('../templates', __FILE__)

      namespace "rrt:devise"
      desc "Copy RRT's custom Devise layouts and Email templates to your project."

      def copy_layouts
        abort "ERROR: Devise is installed, but the Devise installation generator does not appear to have been run. Please run `bin/rails g devise:install` and re-run this generator" and return unless devise? && devise_config_present?
        directory File.expand_path("../../../../app/views/devise/#{handler}", __FILE__), 'app/views/devise'
        copy_file "views/emails/_email_header.html.#{handler}", "app/views/emails/_email_header.html.#{handler}"
        copy_file "views/emails/_email_footer.html.#{handler}", "app/views/emails/_email_footer.html.#{handler}"
      end

      def inject_devise_initializer_config
        abort "ERROR: Devise is installed, but the Devise installation generator does not appear to have been run. Please run `bin/rails g devise:install` and re-run this generator" and return unless devise? && devise_config_present?

        code = <<-INJECTEDCODE.strip_heredoc
          Rails.application.config.to_prepare do
            Devise::Mailer.layout "email"
            Devise::Mailer.send(:include, EmailTemplateHelper)\n
            Devise::Mailer.send(:helper, EmailTemplateHelper)\n
          end\n
  \n
        INJECTEDCODE

        inject_into_file( "config/initializers/devise.rb", code, :before => /^end/)
      end

      protected
        def devise?
          defined?(Devise)
        end

        def devise_config_present?
          File.file?('config/initializers/devise.rb')
        end
    end
  end
end
