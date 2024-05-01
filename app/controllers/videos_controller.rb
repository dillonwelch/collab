class VideosController < ApplicationController
  def index
    # TODO: pagination teehee
    @result = VideoService.get
    @playlists = Playlist.all.pluck(:name, :id)
  end
end
