require 'test_helper'

class DeviseTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "Sign in" do
    get new_user_session_path

    assert_response :success, @response.body
    assert_select ".form-sheet"
  end

  test "Sign up" do
    get new_user_registration_path

    assert_response :success, @response.body
    assert_select ".form-sheet"
  end

  test "Edit" do
    @user = User.first
    sign_in @user.email, 'test'

    get edit_user_registration_path

    assert_response :success, @response.body
    assert_select ".form-horizontal"
  end

  test "New password" do
    get new_user_password_path

    assert_response :success, @response.body
    assert_select ".form-sheet"
  end

  test "Edit password" do
    @user = User.first

    get edit_user_password_path, reset_password_token: 'token'

    assert_response :success, @response.body
    assert_select ".form-sheet"
  end

  test "Confirmation" do
    get new_user_confirmation_path

    assert_response :success, @response.body
    assert_select ".form-sheet"
  end

  test "Unlock" do
    get new_user_unlock_path

    assert_response :success, @response.body
    assert_select ".form-sheet"
  end
end

