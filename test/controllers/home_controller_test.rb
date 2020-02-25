require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_index_url
    assert_template layout: 'application'
    assert_response :success
  end

end
