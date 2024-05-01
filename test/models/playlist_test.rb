require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "validates presence of name" do
    playlist = Playlist.new
    playlist.save
    assert_equal playlist.errors.messages[:name], ["can't be blank"]
  end

  test "validates uniqueness of name" do
    Playlist.create(name: "Good test playlist")
    playlist = Playlist.new(name: "Good test playlist")
    playlist.save
    assert_equal playlist.errors.messages[:name], ["has already been taken"]
  end
end
