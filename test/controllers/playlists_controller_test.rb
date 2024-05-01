require "test_helper"

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test "index with no playlists is successful" do
    get playlists_path
    assert_response :success
  end

  test "index with no playlists displays a proper message" do
    get playlists_path
    assert_select "body>div", "No playlists! Consider making one :)"
  end

  test "index with playlists is successful" do
    Playlist.create!(name: "Cat Videos")
    get playlists_path
    assert_response :success
  end

  # TODO: Test links?
  test "index with playlists displays playlists" do
    Playlist.create!(name: "Cat Videos")
    get playlists_path
    assert_select "td", "Cat Videos"
  end

  test "show with a valid ID and no videos is successful" do
    playlist = Playlist.create!(name: "Cat Videos")
    get playlist_path(playlist.id)
    assert_response :success
  end

  test "show with a valid ID and no videos displays the playlist title " do
    playlist = Playlist.create!(name: "Cat Videos")
    get playlist_path(playlist.id)
    assert_select "h1", "Cat Videos"
  end

  test "show with a valid ID and no videos displays a proper message " do
    playlist = Playlist.create!(name: "Cat Videos")
    get playlist_path(playlist.id)
    assert_select "body>div", "No videos added! Consider adding some :)"
  end

  test "show with a valid ID and videos is successful" do
    playlist = Playlist.create!(name: "Cat Videos")
    # TODO: mock
    PlaylistVideo.create!(playlist: playlist, video_id: "123")
    get playlist_path(playlist.id)
    assert_response :success
  end

  test "show with an invalid ID is unsuccessful" do
    get playlist_path(0)
    assert_response :not_found
  end

  # test "should get show" do
  #   get playlists_show_url
  #   assert_response :success
  # end
  #
  # test "should get create" do
  #   get playlists_create_url
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get playlists_edit_url
  #   assert_response :success
  # end
end
