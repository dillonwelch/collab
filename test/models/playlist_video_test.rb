# frozen_string_literal: true

require 'test_helper'

class PlaylistVideoTest < ActiveSupport::TestCase
  test 'validates presence of playlist association' do
    mock_video_service do
      video = PlaylistVideo.new(playlist_id: '123')
      video.valid?
      assert_equal ['must exist'], video.errors.messages[:playlist]
    end
  end

  test 'validates presence of video_id' do
    mock_video_service do
      video = PlaylistVideo.new
      video.valid?
      assert_equal ["can't be blank"], video.errors.messages[:video_id]
    end
  end

  test 'validates existence of video_id' do
    mock_video_service do
      video = PlaylistVideo.new(video_id: '123')
      video.valid?
      assert_equal ['must exist'], video.errors.messages[:video_id]
    end
  end

  test 'validates position is an integer' do
    mock_video_service do
      video = PlaylistVideo.new(position: 1.1)
      video.valid?
      assert_equal ['must be an integer'], video.errors.messages[:position]
    end
  end

  test 'validates position is a positive number' do
    mock_video_service do
      video = PlaylistVideo.new(position: 0)
      video.valid?
      assert_equal ['must be greater than 0'], video.errors.messages[:position]
    end
  end

  test 'sets position to 1 on create if no videos are on the playlist' do
    mock_video_service do
      playlist = Playlist.create!(name: 'A good playlist')
      playlist_video = PlaylistVideo.create(playlist:, video_id: short_video['video_id'])
      assert_equal 1, playlist_video.position
    end
  end

  test 'sets position to newest on create if videos are on the playlist' do
    mock_video_service do
      playlist = Playlist.create!(name: 'A good playlist')
      PlaylistVideo.create!(playlist:, video_id: short_video['video_id'])
      playlist_video = PlaylistVideo.create!(playlist:, video_id: long_video['video_id'])
      assert_equal 2, playlist_video.position
    end
  end
end
