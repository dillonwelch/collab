# frozen_string_literal: true

# frozen_string_literal => true

require 'test_helper'

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
    test 'clears the relevant caches' do
      VideoService::CACHE_KEYS.each_value do |key|
        Rails.cache.write(key, 'meow')

        assert_equal 'meow', Rails.cache.read(key)
      end

      VideoService.cache_bust

      VideoService::CACHE_KEYS.each_value do |key|
        assert_nil Rails.cache.read(key)
      end
    end
  end

  # If the cache is not working, we will make a second set of API calls which will cause VCR to throw an error.
  class VideoServiceCachingTest < VideoServiceTest
    test 'get uses cache' do
      VCR.use_cassette 'lib/video_service/get', allow_unused_http_interactions: false do
        VideoService.get
        VideoService.get
      end
    end

    test 'get_by_video_id uses cache' do
      VCR.use_cassette 'lib/video_service/get', allow_unused_http_interactions: false do
        VideoService.get_by_video_id('123')
        VideoService.get_by_video_id('123')
      end
    end
  end

  class VideoServiceGetTest < VideoServiceTest
    setup do
      VCR.use_cassette 'lib/video_service/get', allow_unused_http_interactions: false do
        @result = VideoService.get
      end
    end

    test 'contains the right amount of videos' do
      assert_equal 92, @result.length
    end

    test 'contains the right video information' do
      video = {
        'id' => 1,
        'title' => 'thanks for 5 million',
        'video_id' => 'H1tQhK0n5Qk',
        'views' => 279_357,
        'likes' => 66_689,
        'comments' => 3144,
        'description' => '#shorts',
        'thumbnail_url' => 'https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg',
        'created_at' => '2024-04-24T20:59:19.215Z',
        'updated_at' => '2024-04-24T20:59:19.215Z'
      }

      assert_equal video, @result.first
    end
  end

  class VideoServiceGetByVideoIdTest < VideoServiceTest
    test 'returns video information if the video was found' do
      video = {
        'id' => 1,
        'title' => 'thanks for 5 million',
        'video_id' => 'H1tQhK0n5Qk',
        'views' => 279_357,
        'likes' => 66_689,
        'comments' => 3144,
        'description' => '#shorts',
        'thumbnail_url' => 'https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg',
        'created_at' => '2024-04-24T20:59:19.215Z',
        'updated_at' => '2024-04-24T20:59:19.215Z'
      }

      VCR.use_cassette 'lib/video_service/get', allow_unused_http_interactions: false do
        assert_equal video, VideoService.get_by_video_id(video['video_id'])
      end
    end

    test 'returns {} if the video was not found' do
      VCR.use_cassette 'lib/video_service/get', allow_unused_http_interactions: false do
        assert_empty(VideoService.get_by_video_id('not a valid video ID'))
      end
    end
  end
end
