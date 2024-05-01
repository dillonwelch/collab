require "test_helper"

class PlaylistVideoTest < ActiveSupport::TestCase
  test "validates presence of playlist association" do
    video = PlaylistVideo.create(video_id: "123")
    assert_equal video.errors.messages[:playlist], ["must exist"]
  end

  test "validates presence of video_id" do
    video = PlaylistVideo.create
    assert_equal video.errors.messages[:video_id], ["can't be blank"]
  end

  test "sets position to 1 on create if no videos are on the playlist" do
    playlist = Playlist.create!(name: "A good playlist")
    playlist_video = PlaylistVideo.create!(playlist: playlist, video_id: "123")
    assert_equal playlist_video.position, 1
  end

  test "sets position to newest on create if videos are on the playlist" do
    playlist = Playlist.create!(name: "A good playlist")
    PlaylistVideo.create!(playlist: playlist, video_id: "123")
    playlist_video = PlaylistVideo.create!(playlist: playlist, video_id: "456")
    assert_equal playlist_video.position, 2
  end
end
