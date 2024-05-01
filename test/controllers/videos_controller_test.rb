require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get videos_get_url
    assert_response :success
  end
end
