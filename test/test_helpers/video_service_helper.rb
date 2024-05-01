# A helper for mocking out VideoService results.
module VideoServiceHelper
  # TODO: document
  # TODO: extract from other places to here
  # TODO: not a constant?

  def short_video
    {
      "video_id" => "short_video_123",
      "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
      "description" => "Test Description",
      "title" => "Test Title",
      "views" => 5
    }
  end

  def long_video
    {
      "video_id" => "long_video_123",
      "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
      "description" => "meow" * 10,
      "title" => "Long Video Test Title",
      "views" => 6
    }
  end

  # Stubs the result of VideoService.get using mocked data
  def mock_video_service
    VideoService.stub :get, [short_video, long_video] do
      yield
    end
  end
end