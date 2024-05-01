require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  mocked_data = {
    "videos" => [
      {
        "video_id" => "H1tQhK0n5Qk",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "description" => "#shorts",
        "title" => "thanks for 5 million",
        "views" => 279357
      }
    ]
  }

  setup do
    VideoService.stub :get, mocked_data do
      get root_path
    end
  end

  test "index response should be a success" do
    assert_response :success
  end

  test "video image thumbnail is displayed" do
    assert_select(
      "#H1tQhK0n5Qk>div",
      html: '<img alt="Thumbnail image for video H1tQhK0n5Qk" src="https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg">'
    )
  end

  test "video title is displayed" do
    assert_select "#H1tQhK0n5Qk>div", "Title: thanks for 5 million"
  end

  # TODO: test long description
  test "video description is displayed" do
    assert_select "#H1tQhK0n5Qk>div", "Description: #shorts"
  end

  test "video views are displayed" do
    assert_select "#H1tQhK0n5Qk>div", "279357 views"
  end
end
