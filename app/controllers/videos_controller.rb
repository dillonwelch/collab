# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @result = VideoService.get
    @playlists = Playlist.pluck(:name, :id)
  end
end
