# frozen_string_literal => true

require "test_helper"

class VideoServiceTest < ActiveSupport::TestCase
  setup do
    @original_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
  end

  teardown do
    Rails.cache.clear
    Rails.cache = @original_cache
  end

  class VideoServiceCacheBustTest < VideoServiceTest
    test "clears the relevant caches" do
      VideoService::CACHE_KEYS.values.each do |key|
        Rails.cache.write(key, "meow")
        assert_equal "meow", Rails.cache.read(key)
      end

      VideoService.cache_bust

      VideoService::CACHE_KEYS.values.each do |key|
        assert_nil Rails.cache.read(key)
      end
    end
  end

  class VideoServiceGetTest < VideoServiceTest
    setup do
      # TODO: Mock API call
      @result = VideoService.get
    end

    test "contains meta information" do
      assert_equal({ "total" => 92, "page" => 1 }, @result["meta"])
    end

    test "contains the right amount of videos" do
      assert_equal 20, @result["videos"].length
    end

    test "contains the right video information" do
      video = {
        "id" => 1,
        "title" => "thanks for 5 million",
        "video_id" => "H1tQhK0n5Qk",
        "views" => 279357,
        "likes" => 66689,
        "comments" => 3144,
        "description" => "#shorts",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "created_at" => "2024-04-24T20:59:19.215Z",
        "updated_at" => "2024-04-24T20:59:19.215Z"
      }
      assert_equal video, @result["videos"].first
    end
  end

  class VideoServiceGetByVideoIdTest < VideoServiceTest
    test "returns video information if the video was found" do
      video = {
        "id" => 1,
        "title" => "thanks for 5 million",
        "video_id" => "H1tQhK0n5Qk",
        "views" => 279357,
        "likes" => 66689,
        "comments" => 3144,
        "description" => "#shorts",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "created_at" => "2024-04-24T20:59:19.215Z",
        "updated_at" => "2024-04-24T20:59:19.215Z"
      }
      assert_equal video, VideoService.get_by_video_id(video["video_id"])
    end

    test "returns {} if the video was not found" do
      assert_equal({}, VideoService.get_by_video_id("not a valid video ID"))
    end
  end
end
