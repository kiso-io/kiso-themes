require 'test_helper'

class JavascriptsTest < ActionDispatch::IntegrationTest
  test "rrt.js" do
    get "/assets/rrt.js"
  
    assert_response :success
  end
end

