require "generators/kiso_themes/handler_support"

module KisoThemes
  module Generators
    class EmailLayoutGenerator < Rails::Generators::Base
      include HandlerSupport

      source_root File.expand_path('../templates', __FILE__)

      namespace "kiso_themes:email_layout"
      desc "Copy KisoThemes's custom Email templates to your project."

      def copy_layouts
        abort "You must create a mailer first" and return unless mailer?
        copy_file "views/emails/_email_header.html.#{handler}", "app/views/emails/_email_header.html.#{handler}"
        copy_file "views/emails/_email_footer.html.#{handler}", "app/views/emails/_email_footer.html.#{handler}"
      end

      def add_helpers

        code = <<-INJECTEDCODE

  add_template_helper EmailTemplateHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
INJECTEDCODE

        inject_into_file( "app/mailers/application_mailer.rb", code, :after => /^class ApplicationMailer < ActionMailer::Base/)

        gsub_file 'app/mailers/application_mailer.rb', 'mailer', 'email'
      end

      protected

      def mailer?
        File.file?('app/mailers/application_mailer.rb')
      end
    end

  end
end
