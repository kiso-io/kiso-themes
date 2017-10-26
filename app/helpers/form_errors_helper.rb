module FormErrorsHelper
  def error_notification
    return unless object.respond_to?(:errors) && object.errors.any?

    @template.content_tag :div, :class => "alert alert-danger" do
      @template.fa_icon_tag("remove") + " " +
      @template.pluralize(object.errors.count, "errors") +
      " prohibited this #{object_name.to_s.humanize.downcase} from being saved." +
      error_details
    end
  end unless ActionView::Helpers::FormBuilder.method_defined?(:error_notification)

  def error_messages_for(attribute)
    return unless object.respond_to?(:errors) && object.errors.any?
    error_messages = object.errors[attribute]

    @template.content_tag :div, :class => "alert alert-danger" do
      @template.fa_icon_tag("remove") + " " +
      error_messages.map { |message| object.errors.full_message(attribute, message) }.to_sentence
    end
  end unless ActionView::Helpers::FormBuilder.method_defined?(:error_messages_for)

  def error_details
    return unless object.respond_to?(:errors) && object.errors.any?
    messages = object.errors.full_messages.map { |msg| @template.content_tag(:li, msg) }.join

    @template.content_tag :ul, class: 'my-0' do
      messages.html_safe
    end
  end unless ActionView::Helpers::FormBuilder.method_defined?(:error_details)
end

ActionView::Helpers::FormBuilder.send(:include, FormErrorsHelper)
