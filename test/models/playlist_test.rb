require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "validates presence of name" do
    playlist = Playlist.create
    assert_equal playlist.errors.messages[:name], ["can't be blank"]
  end

  test "validates uniqueness of name" do
    Playlist.create!(name: "Good test playlist")
    playlist = Playlist.create(name: "Good test playlist")
    assert_equal playlist.errors.messages[:name], ["has already been taken"]
  end

  test "has an association to PlaylistVideo" do
    playlist = Playlist.create!(name: "Good test playlist")
    one = PlaylistVideo.create!(playlist: playlist, video_id: "123")
    two = PlaylistVideo.create!(playlist: playlist, video_id: "456")
    assert_equal playlist.playlist_videos, [one, two]
  end

  test "destroys associated PlaylistVideos upon destruction" do
    playlist = Playlist.create!(name: "Good test playlist")
    one = PlaylistVideo.create!(playlist: playlist, video_id: "123")
    two = PlaylistVideo.create!(playlist: playlist, video_id: "456")

    assert_changes -> { PlaylistVideo.count }, from: 2, to: 0 do
      playlist.destroy!
    end
  end
end
