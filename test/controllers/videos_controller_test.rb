require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  def visit_index(playlist: true)
    Playlist.create!(name: "Good Playlist") if playlist
    mock_video_service { get root_path }
  end

  test "index page displays video information" do
    visit_index

    assert_response :success

    assert_select "##{short_video['video_id']}>div" do
      # assert_select(
      #   "##{short_video['video_id']}>div",
      #   html: "<img alt=\"Thumbnail image for video #{short_video['video_id']}\" src=\"#{short_video['thumbnail_url']}\">"
      # )
      assert_select ".title", "#{short_video['title']}"
      assert_select ".description", "#{short_video['description']}"
      assert_select ".views", "#{short_video['views']} views"
    end
  end

  test "video description is truncated when long" do
    visit_index
    # TODO: test long description with ...
    assert_select "##{long_video['video_id']}>div" do
      assert_select ".description", long_video['description'].first(100)
    end
  end

  test "add to playlist is hidden if there are no playlists" do
    visit_index(playlist: false)
    assert_select "##{short_video['video_id']}>form", false
  end

  test "add to playlist is present if there are playlists" do
    visit_index
    assert_select "##{short_video['video_id']}>form", "Good Playlist"
  end
end
