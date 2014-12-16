require 'test_helper'

class FormErrorsHelperTest < ActionView::TestCase
  class User
    include ActiveModel::Validations

    attr_accessor :name

    validates :name, :presence => true
  end

  setup do
    @object = User.new
    @builder = ActionView::Helpers::FormBuilder.new(:user, @object, view, {})
  end

  test "error_notification" do
    @object.valid?
    assert_select document(@builder.error_notification), "div.alert"
  end

  test "error_notification, no errors" do
    assert_select document(@builder.error_notification), "div.alert", 0
  end

  test "error_messages_for" do
    @object.valid?
    assert_select document(@builder.error_messages_for(:name)), "div.alert"
  end

  test "error_messages_for, no errors" do
    assert_select document(@builder.error_messages_for(:name)), "div.alert", 0
  end

  protected
    def document(html)
      HTML::Document.new(html.to_s).root
    end

end
