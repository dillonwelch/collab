require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  # TODO: extract?
  MOCKED_DATA = {
    "videos" => [
      {
        "video_id" => "short_video_123",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "description" => "Test Description",
        "title" => "Test Title",
        "views" => 5
      },
      {
        "video_id" => "long_video_123",
        "thumbnail_url" => "https://i.ytimg.com/vi/H1tQhK0n5Qk/default.jpg",
        "description" => "meow" * 10,
        "title" => "Long Video Test Title",
        "views" => 6
      },
    ]
  }
  SHORT_VIDEO = MOCKED_DATA["videos"].first
  LONG_VIDEO = MOCKED_DATA["videos"].second

  # TODO: use setup?
  def visit_index(playlist: true)
    VideoService.stub :get, MOCKED_DATA do
      Playlist.create!(name: "Good Playlist") if playlist
      get root_path
    end
  end

  test "index response should be a success" do
    visit_index
    assert_response :success
  end

  test "video image thumbnail is displayed" do
    visit_index
    assert_select(
      "##{SHORT_VIDEO['video_id']}>div",
      html: "<img alt=\"Thumbnail image for video #{SHORT_VIDEO['video_id']}\" src=\"#{SHORT_VIDEO['thumbnail_url']}\">"
    )
  end

  test "video title is displayed" do
    visit_index
    assert_select "##{SHORT_VIDEO['video_id']}>div", "Title: #{SHORT_VIDEO['title']}"
  end

  test "video description is displayed" do
    visit_index
    assert_select "##{SHORT_VIDEO['video_id']}>div", "Description: #{SHORT_VIDEO['description']}"
  end

  test "video description is truncated when long" do
    visit_index
    # TODO: test long description with ...
    assert_select "##{LONG_VIDEO['video_id']}>div",  "Description: #{LONG_VIDEO['description'].first(20)}"
  end

  test "video views are displayed" do
    visit_index
    assert_select "##{SHORT_VIDEO['video_id']}>div", "#{SHORT_VIDEO['views']} views"
  end

  test "add to playlist is hidden if there are no playlists" do
    visit_index(playlist: false)
    assert_select "##{SHORT_VIDEO['video_id']}>form", false
  end

  test "add to playlist is present if there are playlists" do
    visit_index
    assert_select "##{SHORT_VIDEO['video_id']}>form", "Good Playlist"
  end
end
