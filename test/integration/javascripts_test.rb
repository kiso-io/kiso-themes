require 'test_helper'

class JavascriptsTest < ActionDispatch::IntegrationTest
  test "dresssed.js" do
    get "/assets/dresssed.js"
  
    assert_response :success
  end
end

