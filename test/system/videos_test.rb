require "application_system_test_case"

class VideosTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  test "visiting the home page" do
    mock_video_service do
      visit root_path

      assert_text "Short Video"
      assert_text "Long Video"
    end
  end

  test "adding a playlist" do
    mock_video_service do
      visit root_path

      assert_changes -> { Playlist.where(name: "Cat Videos").count }, 1 do
        click_on "Create Playlist"
        fill_in "Name", with: "Cat Videos"
        click_button "Create Playlist"

        assert_text "No videos added! Consider adding some :)"
      end
    end
  end

  test "editing a playlist" do
    mock_video_service do
      playlist = Playlist.create!(name: "Cat Videos")

      assert_changes -> { playlist.reload.name }, from: "Cat Videos", to: "Dog Videos" do
        visit root_path

        click_on "All Playlists"
        click_on "Edit"
        fill_in "Name", with: "Dog Videos"
        click_button "Update Playlist"

        assert_text "No videos added! Consider adding some :)"
      end
    end
  end

  test "viewing a playlist" do
    mock_video_service do
     Playlist.create!(name: "Cat Videos")

      visit root_path

      click_on "All Playlists"
      click_on "View"

      assert_text "Cat Videos"
    end
  end

  test "deleting a playlist" do
    mock_video_service do
      Playlist.create!(name: "Cat Videos")

      assert_changes -> { Playlist.where(name: "Cat Videos").count }, -1 do
        visit root_path

        click_on "All Playlists"
        click_on "Delete"

        refute_text "Cat Videos"
        assert_text "No playlists! Consider making one :)"
      end
    end
  end
end