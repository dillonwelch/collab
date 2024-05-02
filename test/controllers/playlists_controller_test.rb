require "test_helper"

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  # TODO: Test playlist links after UI is finalized
  class PlaylistsControllerIndexTest < PlaylistsControllerTest
    test "request with no playlists displays a 'No Playlists' message" do
      get playlists_path

      assert_response :success
      assert_match "No playlists! Consider making one :)", @response.body
    end

    test "request with playlists displays playlist information" do
      Playlist.create!(name: "Cat Videos")

      get playlists_path

      assert_response :success
      assert_match "Cat Videos", @response.body
    end
  end

  class PlaylistsControllerShowTest < PlaylistsControllerTest
    test "request with a valid ID and no videos displays the playlist info and a 'No Videos' message" do
      playlist = Playlist.create!(name: "Cat Videos")

      get playlist_path(playlist.id)

      assert_response :success
      assert_match "Cat Videos", @response.body
      assert_match "No videos added! Consider adding some :)", @response.body
    end

    test "request with a valid ID and videos displays the playlist info and video info" do
      mock_video_service do
        playlist = Playlist.create!(name: "Cat Videos")
        PlaylistVideo.create!(playlist: playlist, video_id: short_video["video_id"])

        get playlist_path(playlist.id)

        assert_response :success
        assert_match "Cat Videos", @response.body
        assert_match "#{short_video["title"]}", @response.body
      end
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
      assert_match "Create Playlist", @response.body
    end
  end

  class PlaylistsControllerCreateTest < PlaylistsControllerTest
    test "request creates a new playlist with valid params" do
      assert_difference -> { Playlist.where(name: "Cat Videos").count }, 1 do
        post playlists_path, params: { playlist: { name: "Cat Videos" } }
      end

      assert_redirected_to playlist_path(Playlist.last)
      assert_match "Playlist \"Cat Videos\" successfully created.", flash[:notice]
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
      assert_match "Update Playlist", @response.body
      assert_match "Cat Videos", @response.body
    end
  end

  class PlaylistsControllerUpdateTest < PlaylistsControllerTest
    test "request with valid params updates the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")

      assert_changes -> { playlist.reload.name }, from: "Cat Videos", to: "Dog Videos" do
        patch playlist_path(playlist), params: { playlist: { name: "Dog Videos" } }
      end

      assert_redirected_to playlist_path(playlist)
      assert_match "Playlist \"Dog Videos\" successfully updated.", flash[:notice]
    end

    test "request with a duplicated name does not update the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")
      Playlist.create!(name: "Dog Videos")

      assert_no_changes -> { playlist.reload.name } do
        patch playlist_path(playlist), params: { playlist: { name: "Dog Videos" } }
      end

      assert_match "Name has already been taken", @response.body
    end

    test "request with an empty name does not update the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")

      assert_no_changes -> { playlist.reload.name } do
        patch playlist_path(playlist), params: { playlist: { name: "" } }
      end

      assert_match "Name can&#39;t be blank", @response.body
    end
  end

  class PlaylistsControllerDestroyTest < PlaylistsControllerTest
    test "request destroys the playlist" do
      playlist = Playlist.create!(name: "Cat Videos")

      assert_difference -> { Playlist.where(name: "Cat Videos").count }, -1 do
        delete playlist_path(playlist)
      end

      assert_redirected_to playlists_path
      assert_match "Playlist \"Cat Videos\" successfully deleted.", flash[:notice]
    end
  end
end
