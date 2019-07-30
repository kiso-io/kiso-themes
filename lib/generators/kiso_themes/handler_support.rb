module KisoThemes
  module Generators
    module HandlerSupport
      extend ActiveSupport::Concern

      included do
        class_option :template_engine
      end

      protected
        def supported_handlers
          %w(erb haml slim)
        end

        def handler
          handler = options[:template_engine].to_s.gsub('erubis', 'erb')
          handler = 'erb' unless supported_handlers.include?(handler) # Default to ERB if handler is unsupported
          handler
        end

        def unsupported_handlers
          supported_handlers - [ handler ]
        end

    end
  end
end
