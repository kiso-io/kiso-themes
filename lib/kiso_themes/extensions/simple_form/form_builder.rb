module KisoThemes
  module SimpleForm
    module FormBuilderExtensions
      def cancel_button(*args)
        options = args.extract_options!
        url = options[:to] || :back
        template.link_to translate_required_text, url, class: 'btn'
      end

      def translate_required_text
        I18n.t(:"simple_form.buttons.cancel", default: 'Cancel')
      end
    end
  end
end

SimpleForm::FormBuilder.send(:include, KisoThemes::SimpleForm::FormBuilderExtensions)
