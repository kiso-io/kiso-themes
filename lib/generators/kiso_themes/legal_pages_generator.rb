require "generators/kiso_themes/handler_support"

module KisoThemes
  module Generators
    class LegalPagesGenerator < Rails::Generators::Base
      include HandlerSupport

      namespace "kiso_themes:legal_pages"
      desc "Installs the KisoThemes legal pages into the your chosen directory."

      source_root File.expand_path('../templates/', __FILE__)

      def create_controller
        invoke :controller, ['legal', ['privacy', 'terms_of_service']], skip: false, skip_routes: false, helper: false, test_framework: false, assets: false, template_engine: false
      end

      def copy_legal_pages
        ['terms_of_service_page', 'privacy_page'].each do |page_name|
          copy_file "views/frontend_pages/legal_pages/#{page_name}.html.#{handler}",
            "app/views/legal/#{page_name.gsub(/_page/, '')}.html.#{handler}"
        end
      end
    end
  end
end
