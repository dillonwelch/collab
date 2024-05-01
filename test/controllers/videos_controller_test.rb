require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  mocked_data = {
    "videos" => [
      {
        "video_id" => "short_video_123",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "description" => "Test Description",
        "title" => "Test Title",
        "views" => 5
      },
      {
        "video_id" => "long_video_123",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "description" => "meow" * 10,
        "title" => "Long Video Test Title",
        "views" => 5
      },
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
      "#short_video_123>div",
      html: '<img alt="Thumbnail image for video short_video_123" src="https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg">'
    )
  end

  test "video title is displayed" do
    assert_select "#short_video_123>div", "Title: Test Title"
  end

  test "video description is displayed" do
    assert_select "#short_video_123>div", "Description: Test Description"
  end

  test "video description is truncated when long" do
    # TODO: test long description with ...
    assert_select "#long_video_123>div", "Description: meowmeowmeowmeowmeow"
  end

  test "video views are displayed" do
    assert_select "#short_video_123>div", "5 views"
  end
end
