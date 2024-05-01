class VideosController < ApplicationController
  def index
    # TODO: pagination teehee
    # TODO: clear cache
    @result = VideoService.get
    @playlists = Playlist.all.pluck(:name, :id)
  end
end
