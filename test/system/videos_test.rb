require "application_system_test_case"

class VideosTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  test "visiting the index" do
    mock_video_service do
      visit root_path

      assert_text "Short Video"
      assert_text "Long Video"
    end
  end
end