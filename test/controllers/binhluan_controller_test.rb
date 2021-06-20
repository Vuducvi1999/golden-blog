require "test_helper"

class BinhluanControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get binhluan_create_url
    assert_response :success
  end
end
