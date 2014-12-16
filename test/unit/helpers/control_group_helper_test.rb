require 'test_helper'

class ControlGroupHelperTest < ActionView::TestCase
  class User
    include ActiveModel::Validations

    attr_accessor :name

    validates :name, :presence => true
  end

  setup do
    @object = User.new
    @form_builder = ActionView::Helpers::FormBuilder.new(:user, @object, view, {})
    @builder = ControlGroupBuilder.new(view, :name, @form_builder)
  end

  test "has_errors?" do
    assert !@builder.has_errors?
  end

  test "has_errors? with errors" do
    assert !@object.valid?
    assert @builder.has_errors?
  end

  test "has_errors? with nil object" do
    @form_builder.expects(:object).returns(nil)
    assert !@builder.has_errors?
  end

  test "error_messages without errors is nil" do
    assert_nil @builder.error_messages
  end

  test "error_messages with errors" do
    @object.valid?
    assert_select HTML::Document.new(@builder.error_messages).root, "span"
  end

  test "delegate unknown methods calls to FormBuilder" do
    assert_select HTML::Document.new(@builder.label(:name)).root, "label"
  end
end
