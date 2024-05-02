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
      Playlist.create!(name: "Chicken Videos")

      assert_changes -> { playlist.reload.name }, from: "Cat Videos", to: "Dog Videos" do
        visit root_path

        click_on "All Playlists"

        within "#playlist-#{playlist.id}" do
          click_on "Edit"
        end

        fill_in "Name", with: "Dog Videos"
        click_button "Update Playlist"

        assert_text "No videos added! Consider adding some :)"
      end
    end
  end

  test "viewing a playlist" do
    mock_video_service do
      playlist = Playlist.create!(name: "Cat Videos")
      Playlist.create!(name: "Chicken Videos")

      visit root_path

      click_on "All Playlists"
      within "#playlist-#{playlist.id}" do
        click_on "View"
      end

      assert_text "Cat Videos"
    end
  end

  test "deleting a playlist" do
    mock_video_service do
      playlist = Playlist.create!(name: "Cat Videos")
      Playlist.create!(name: "Chicken Videos")

      assert_changes -> { Playlist.where(name: "Cat Videos").count }, -1 do
        visit root_path

        click_on "All Playlists"
        within "#playlist-#{playlist.id}" do
          click_on "Delete"
        end

        refute_text "Cat Videos"
        assert_text "Chicken Videos"
      end
    end
  end

  # test "adding a video to a playlist" do
  #   Playlist.create!(name: "Cat Videos")
  #   Playlist.create!(name: "Dog Videos")
  #
  #   assert_changes -> { PlaylistVideo.count }, 1 do
  #     mock_video_service do
  #       # puts "root 1: #{VideoService.get}"
  #       # puts "root get 1: #{VideoService.get_by_video_id('123')}"
  #       visit root_path
  #       visit playlists_path
  #       visit root_path
  #     end
  #
  #     within "##{short_video["video_id"]}" do
  #       # puts "1: #{VideoService.get}"
  #       # puts "2: #{VideoService.get}"
  #       # puts "3: #{VideoService.get}"
  #       # puts "get 1: #{VideoService.get_by_video_id('123')}"
  #       # puts "get 2: #{VideoService.get_by_video_id('123')}"
  #       # puts "get 3: #{VideoService.get_by_video_id('123')}"
  #       # puts "get 4: #{VideoService.get_by_video_id('123')}"
  #
  #       select "Dog Videos"
  #       mock_video_service do
  #         # mock = Minitest::Mock.new
  #         # mock.expect :video, short_video
  #         PlaylistVideo.stub_any_instance(:video, short_video) do
  #           String.stub_any_instance(:length, 42) do
  #             puts "length: #{'hello'.length}"
  #             assert_equal "hello".length, 42
  #           end
  #           video = PlaylistVideo.new
  #           puts "pls: #{video.video}"
  #           click_on "Add to playlist"
  #         end
  #       end
  #     end
  #   end
  # end
end
