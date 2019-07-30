require 'test_helper'

class JavascriptsTest < ActionDispatch::IntegrationTest
  test "kiso_themes.js" do
    get "/assets/kiso_themes.js"
  
    assert_response :success
  end
end

