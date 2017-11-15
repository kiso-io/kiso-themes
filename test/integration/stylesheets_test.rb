require 'test_helper'

class StylesheetsTest < ActionDispatch::IntegrationTest
  RRT::Ives::STYLES.each do |style|
    test "#{style}.css" do
      get "/assets/styles/#{style}.css"

      assert_response :success
    end
  end
end

