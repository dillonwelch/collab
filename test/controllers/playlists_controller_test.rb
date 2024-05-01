require "test_helper"

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  # TODO: Test header links after UI is finalized
  # TODO: Test playlist links after UI is finalized
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

  class PlaylistsControllerNewTest < PlaylistsControllerTest
    test "request is successful" do
      get new_playlist_path
      assert_response :success
      # TODO: Update after UI finalized
      assert_select "body", /Create Playlist/
    end
  end

  class PlaylistsControllerCreateTest < PlaylistsControllerTest
    test "request creates a new playlist with valid params" do
      assert_difference -> { Playlist.where(name: "Cat Videos").count }, 1 do
        post playlists_path, params: { playlist: { name: "Cat Videos" } }
      end

      assert_redirected_to playlist_path(Playlist.last)
    end

    test "request with a duplicated name does not create a new playlist" do
      Playlist.create!(name: "Cat Videos")

      assert_difference -> { Playlist.where(name: "Cat Videos").count }, 0 do
        post playlists_path, params: { playlist: { name: "Cat Videos" } }
      end

      assert_match "Name has already been taken", @response.body
    end

    test "request with an empty name does not create a new playlist" do
      assert_difference -> { Playlist.count }, 0 do
        post playlists_path, params: { playlist: { name: "" } }
      end

      assert_match "Name can&#39;t be blank", @response.body
    end
  end

  class PlaylistsControllerEditTest < PlaylistsControllerTest
    test "request is successful" do
      playlist = Playlist.create!(name: "Cat Videos")
      get edit_playlist_path(playlist)
      assert_response :success
      # TODO: Update after UI finalized
      assert_match "Update Playlist", @response.body
      assert_match "Cat Videos", @response.body
    end
  end

  class PlaylistsControllerUpdateTest < PlaylistsControllerTest
    test "request with valid params updates the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")
      patch playlist_path(playlist), params: { playlist: { name: "Dog Videos" } }
      assert_redirected_to playlist_path(playlist)
    end

    # TODO: standardize verbiage across test names
    test "request with a duplicated name does not update the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")
      playlist2 = Playlist.create!(name: "Dog Videos")

      patch playlist_path(playlist), params: { playlist: { name: "Dog Videos" } }

      assert_match "Name has already been taken", @response.body
    end

    test "request with an empty name does not update the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")

      patch playlist_path(playlist), params: { playlist: { name: "" } }

      assert_match "Name can&#39;t be blank", @response.body
    end
  end
end
