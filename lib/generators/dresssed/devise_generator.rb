require "generators/dresssed/handler_support"

module Dresssed
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      include HandlerSupport

      source_root File.expand_path('../templates', __FILE__)

      desc "Copy Dresssed's custom Devise layouts and Email templates to your project."

      def copy_layouts
        directory File.expand_path("../../../../app/views/devise/#{handler}", __FILE__), 'app/views/devise'
        copy_file "views/emails/_email_header.html.#{handler}", "app/views/emails/_email_header.html.#{handler}"
        copy_file "views/emails/_email_footer.html.#{handler}", "app/views/emails/_email_footer.html.#{handler}"
      end

      def inject_devise_initializer_config
        code = <<-INJECTEDCODE.strip_heredoc
        Rails.application.config.to_prepare do
          Devise::SessionsController.layout "_minimal"
          Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "_minimal" }
          Devise::ConfirmationsController.layout "_minimal"
          Devise::UnlocksController.layout "_minimal"
          Devise::PasswordsController.layout "_minimal"

          Devise::Mailer.layout "email"
        end\n
\n
        Devise::Mailer.class_eval do
          helper :email_template # includes "EmailTemplateHelper"
        end\n
        INJECTEDCODE

        inject_into_file( "config/initializers/devise.rb", code, :before => /^end/)
      end
    end
  end
end
