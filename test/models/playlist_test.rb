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

  test "has an association to PlaylistSong" do
    playlist = Playlist.create!(name: "Good test playlist")
    one = PlaylistSong.create!(playlist: playlist, video_id: "123")
    two = PlaylistSong.create!(playlist: playlist, video_id: "456")
    assert_equal playlist.playlist_songs, [one, two]
  end
end
