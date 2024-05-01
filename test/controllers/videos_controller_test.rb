require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  # TODO: use setup?
  def visit_index(playlist: true)
    Playlist.create!(name: "Good Playlist") if playlist
    mock_video_service { get root_path }
  end

  test "index response should be a success" do
    visit_index
    assert_response :success
  end

  test "video image thumbnail is displayed" do
    visit_index
    assert_select(
      "##{short_video['video_id']}>div",
      html: "<img alt=\"Thumbnail image for video #{short_video['video_id']}\" src=\"#{short_video['thumbnail_url']}\">"
    )
  end

  test "video title is displayed" do
    visit_index
    assert_select "##{short_video['video_id']}>div", "Title: #{short_video['title']}"
  end

  test "video description is displayed" do
    visit_index
    assert_select "##{short_video['video_id']}>div", "Description: #{short_video['description']}"
  end

  test "video description is truncated when long" do
    visit_index
    # TODO: test long description with ...
    assert_select "##{long_video['video_id']}>div",  "Description: #{long_video['description'].first(20)}"
  end

  test "video views are displayed" do
    visit_index
    assert_select "##{short_video['video_id']}>div", "#{short_video['views']} views"
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
