# frozen_string_literal: true

require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test 'validates presence of name' do
    playlist = Playlist.create

    assert_equal ["can't be blank"], playlist.errors.messages[:name]
  end

  test 'validates uniqueness of name' do
    Playlist.create!(name: 'Good test playlist')
    playlist = Playlist.create(name: 'Good test playlist')

    assert_equal ['has already been taken'], playlist.errors.messages[:name]
  end

  test 'has an association to PlaylistVideo' do
    mock_video_service do
      playlist = Playlist.create!(name: 'Good test playlist')
      one = PlaylistVideo.create!(playlist:, video_id:  short_video['video_id'])
      two = PlaylistVideo.create!(playlist:, video_id:  long_video['video_id'])

      assert_equal playlist.playlist_videos, [one, two]
    end
  end

  test 'destroys associated PlaylistVideos upon destruction' do
    mock_video_service do
      playlist = Playlist.create!(name: 'Good test playlist')
      PlaylistVideo.create!(playlist:, video_id:  short_video['video_id'])
      PlaylistVideo.create!(playlist:, video_id:  long_video['video_id'])

      assert_changes -> { PlaylistVideo.count }, from: 2, to: 0 do
        playlist.destroy!
      end
    end
  end
end
