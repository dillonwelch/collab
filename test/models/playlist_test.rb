require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test 'validates presence of name' do
    playlist = Playlist.create
    assert_equal playlist.errors.messages[:name], ["can't be blank"]
  end

  test 'validates uniqueness of name' do
    Playlist.create!(name: 'Good test playlist')
    playlist = Playlist.create(name: 'Good test playlist')
    assert_equal playlist.errors.messages[:name], ['has already been taken']
  end

  test 'has an association to PlaylistVideo' do
    mock_video_service do
      playlist = Playlist.create!(name: 'Good test playlist')
      one = PlaylistVideo.create!(playlist: playlist, video_id:  short_video['video_id'])
      two = PlaylistVideo.create!(playlist: playlist, video_id:  long_video['video_id'])

      assert_equal playlist.playlist_videos, [one, two]
    end
  end

  test 'destroys associated PlaylistVideos upon destruction' do
    mock_video_service do
      playlist = Playlist.create!(name: 'Good test playlist')
      one = PlaylistVideo.create!(playlist: playlist, video_id:  short_video['video_id'])
      two = PlaylistVideo.create!(playlist: playlist, video_id:  long_video['video_id'])

      assert_changes -> { PlaylistVideo.count }, from: 2, to: 0 do
        playlist.destroy!
      end
    end
  end
end
