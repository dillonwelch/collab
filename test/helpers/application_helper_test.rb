# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  class HeaderItemTest < ApplicationHelperTest
    test "inactive header does not have active classes" do
      request.stub :original_fullpath, "/playlists" do
        assert_dom_equal %{<a class="nav-link" href="/">meow</a>}, header_item("meow", "/")
      end
    end

    test "active header has active classes" do
      request.stub :original_fullpath, "/" do
        assert_dom_equal %{<a class="nav-link active" aria-current="page" href="/">meow</a>}, header_item("meow", "/")
      end
    end
  end
end
