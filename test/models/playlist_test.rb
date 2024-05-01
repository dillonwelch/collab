require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "validates presence of name" do
    playlist = Playlist.new
    playlist.save
    assert_equal playlist.errors.messages[:name], ["can't be blank"]
  end
end
