module Dresssed
  module SimpleForm
    # Custom SimpleForm component to add a 'Required' tag next to required inputs when
    # there are no errors.
    module RequiredTag
      def required_tag
        return unless required_field? && !has_errors?
        template.content_tag :div,
                             template.icon_tag("asterisk") + " " + translate_required_text,
                             :class => "help-block"
      end

      def translate_required_text
        I18n.t(:"simple_form.required.text", :default => 'required')
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, Dresssed::SimpleForm::RequiredTag)