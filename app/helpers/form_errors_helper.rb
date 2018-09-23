module FormErrorsHelper
  unless ActionView::Helpers::FormBuilder.method_defined?(:error_notification)
    def error_notification
      return unless object.respond_to?(:errors) && object.errors.any?

      error_count = object.errors.count
      humanized_name = I18n.t("activerecord.models.#{object_name.to_s.downcase}.one",
                              default: object_name.to_s.humanize)

      default_error_message = "#{@template.pluralize(error_count, 'errors')} prohibited this #{humanized_name} from being saved."
      error_message = I18n.t('activerecord.errors.template.header',
                             count: error_count,
                             model: humanized_name,
                             default: default_error_message)

      @template.content_tag :div, class: 'alert alert-danger' do
        @template.fa_icon_tag('remove') + ' ' +
          error_message +
          error_details
      end
    end
  end

  unless ActionView::Helpers::FormBuilder.method_defined?(:error_messages_for)
    def error_messages_for(attribute)
      return unless object.respond_to?(:errors) && object.errors.any?

      error_messages = object.errors[attribute]

      @template.content_tag :div, class: 'alert alert-danger' do
        @template.fa_icon_tag('remove') + ' ' +
          error_messages.map { |message| object.errors.full_message(attribute, message) }.to_sentence
      end
    end
  end

  unless ActionView::Helpers::FormBuilder.method_defined?(:error_details)
    def error_details
      return unless object.respond_to?(:errors) && object.errors.any?

      messages = object.errors.full_messages.map { |msg| @template.content_tag(:li, msg) }.join

      @template.content_tag :ul, class: 'my-0' do
        messages.html_safe
      end
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, FormErrorsHelper)
