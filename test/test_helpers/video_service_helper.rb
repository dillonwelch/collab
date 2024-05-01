module VideoServiceHelper
  # TODO: document
  # TODO: extract from other places to here
  # TODO: not a constant?
  MOCKED_DATA = {
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
        "views" => 6
      },
    ]
  }

  def mock_video_service
    VideoService.stub :get, MOCKED_DATA do
      yield
    end
  end
end