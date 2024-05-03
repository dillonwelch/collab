# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @result = VideoService.get
    @playlists = Playlist.all.pluck(:name, :id)
  end
end
