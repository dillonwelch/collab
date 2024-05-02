require "test_helper"

class PlaylistVideosControllerTest < ActionDispatch::IntegrationTest
  class PlaylistVideosControllerCreateTest < PlaylistVideosControllerTest
    test "request with valid params creates a playlist video" do
      mock_video_service do
        playlist = Playlist.create!(name: "Cat Videos")

        assert_changes -> { playlist.playlist_videos.count }, 1 do
          post(
            playlist_videos_path,
            params: { playlist_video: { playlist_id: playlist.id, video_id: short_video["video_id"] } }
          )
        end

        assert_response :no_content
      end
    end

    test "request with invalid playlist_id does not create a playlist video" do
      mock_video_service do
        playlist = Playlist.create!(name: "Cat Videos")

        assert_no_changes -> { playlist.playlist_videos.count } do
          post playlist_videos_path, params: { playlist_video: { playlist_id: 0, video_id: short_video["video_id"] } }
        end

        assert_response :unprocessable_entity
      end
    end
  end

  class PlaylistVideosControllerDestroyTest < PlaylistVideosControllerTest
    test "request destroys the playlist video" do
      mock_video_service do
        playlist = Playlist.create!(name: "Cat Videos")
        video = PlaylistVideo.create!(playlist: playlist, video_id: short_video["video_id"])

        assert_difference -> { PlaylistVideo.where(playlist: playlist).count }, -1 do
          delete playlist_video_path(playlist)
        end

        assert_redirected_to playlist_path(playlist)
        assert_match "Playlist entry successfully deleted.", flash[:notice]
      end
    end
  end

  class PlaylistVideosControllerSwapTest < PlaylistVideosControllerTest
    test"swaps the position of two playlist videos" do
      mock_video_service do
        playlist = Playlist.create!(name: "Cat Videos")
        from_video = PlaylistVideo.create!(playlist: playlist, video_id: short_video["video_id"])
        to_video = PlaylistVideo.create!(playlist: playlist, video_id: long_video["video_id"])

        assert_changes -> { from_video.reload.position }, from: 1, to: 2 do
          assert_changes -> { to_video.reload.position }, from: 2, to: 1 do
            patch playlist_videos_swap_path, params: { from_id: from_video.id, to_id: to_video.id }
          end
        end
      end
    end
  end
end
