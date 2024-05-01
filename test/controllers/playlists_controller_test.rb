require "test_helper"

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  # TODO: Test header links?
  class PlaylistsControllerIndexTest < PlaylistsControllerTest
    test "request with no playlists is successful" do
      get playlists_path
      assert_response :success
    end

    test "request with no playlists displays a 'No Playlists' message" do
      get playlists_path
      assert_select "body>div", "No playlists! Consider making one :)"
    end

    test "request with playlists is successful" do
      Playlist.create!(name: "Cat Videos")
      get playlists_path
      assert_response :success
    end

    # TODO: Test links after UI is finalized
    test "request with playlists displays playlist information" do
      Playlist.create!(name: "Cat Videos")
      get playlists_path
      assert_select "td", "Cat Videos"
    end
  end

  class PlaylistsControllerShowTest < PlaylistsControllerTest
    test "request with a valid ID and no videos is successful" do
      playlist = Playlist.create!(name: "Cat Videos")
      get playlist_path(playlist.id)
      assert_response :success
    end

    test "request with a valid ID and no videos displays the playlist title " do
      playlist = Playlist.create!(name: "Cat Videos")
      get playlist_path(playlist.id)
      assert_select "h1", "Cat Videos"
    end

    test "request with a valid ID and no videos displays a 'No videos' message " do
      playlist = Playlist.create!(name: "Cat Videos")
      get playlist_path(playlist.id)
      assert_select "body>div", "No videos added! Consider adding some :)"
    end

    test "request with a valid ID and videos is successful" do
      playlist = Playlist.create!(name: "Cat Videos")
      PlaylistVideo.create!(playlist: playlist, video_id: "short_video_123")
      mock_video_service { get playlist_path(playlist.id) }
      assert_response :success
    end

    test "request with a valid ID and videos displays the playlist title" do
      playlist = Playlist.create!(name: "Cat Videos")
      PlaylistVideo.create!(playlist: playlist, video_id: "short_video_123")
      mock_video_service { get playlist_path(playlist.id) }
      assert_select "h1", "Cat Videos"
    end

    test "request with a valid ID and videos displays video information" do
      playlist = Playlist.create!(name: "Cat Videos")
      # TODO: Factory Bot
      PlaylistVideo.create!(playlist: playlist, video_id: "short_video_123")
      mock_video_service { get playlist_path(playlist.id) }
      # TODO: update after UI is finalized
      assert_select "body>div", /ID: short_video_123/
    end

    test "request with an invalid ID is unsuccessful" do
      get playlist_path(0)
      assert_response :not_found
    end
  end
end
