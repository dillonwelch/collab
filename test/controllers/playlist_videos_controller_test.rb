require "test_helper"

class PlaylistVideosControllerTest < ActionDispatch::IntegrationTest
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
