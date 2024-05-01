require "test_helper"

class PlaylistVideoTest < ActiveSupport::TestCase
  test "validates presence of playlist association" do
    video = PlaylistVideo.create(video_id: "123")
    assert_equal ["must exist"], video.errors.messages[:playlist]
  end

  test "validates presence of video_id" do
    video = PlaylistVideo.create
    assert_equal ["can't be blank"], video.errors.messages[:video_id]
  end

  test "validates position is an integer" do
    video = PlaylistVideo.new(position: 1.1)
    video.valid?
    assert_equal ["must be an integer"], video.errors.messages[:position]
  end

  test "validates position is a positive number" do
    video = PlaylistVideo.new(position: 0)
    video.valid?
    assert_equal ["must be greater than 0"], video.errors.messages[:position]
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
