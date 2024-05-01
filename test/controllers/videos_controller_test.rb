require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  test "index response should be a success" do
    get root_path
    assert_response :success
  end

  test "video image thumbnail is displayed" do
    get root_path
    assert_select(
      "#H1tQhK0n5Qk>div",
      html: '<img alt="Thumbnail image for video H1tQhK0n5Qk" src="https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg">'
    )
  end

  test "video title is displayed" do
    get root_path
    assert_select "#H1tQhK0n5Qk>div", "Title: thanks for 5 million"
  end

  # TODO: test long description
  test "video description is displayed" do
    get root_path
    assert_select "#H1tQhK0n5Qk>div", "Description: #shorts"
  end

  test "video views are displayed" do
    get root_path
    assert_select "#H1tQhK0n5Qk>div", "279357 views"
  end
end
