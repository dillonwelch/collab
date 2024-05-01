# A helper for mocking out VideoService results.
module VideoServiceHelper
  # JSON data for a video with a short description.
  # @return [Hash] Video data.
  def short_video
    {
      "video_id" => "short_video_123",
      "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
      "description" => "Test Description",
      "title" => "Short Video",
      "views" => 5
    }
  end

  # JSON data for a video with a large description.
  # @return [Hash] Video data.
  def long_video
    {
      "video_id" => "long_video_123",
      "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
      "description" => "meow" * 10,
      "title" => "Long Video",
      "views" => 6
    }
  end

  # Stubs the result of VideoService.get using mocked data.
  # @yield [nil] Wraps the yield within a stub call.
  def mock_video_service
    VideoService.stub :get, [short_video, long_video] do
      yield
    end
  end
end