class VideosController < ApplicationController
  def index
    # TODO: clear cache
    @result = VideoService.get
    @playlists = Playlist.all.pluck(:name, :id)
  end
end
