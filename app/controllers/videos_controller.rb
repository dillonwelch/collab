class VideosController < ApplicationController
  def index
    # TODO: pagination teehee
    # TODO: clear cache
    # puts "videos controller: #{request.original_url}"
    # puts "controller get 1: #{VideoService.get}"
    # puts "controller get id 1: #{VideoService.get_by_video_id('123')}"
    @result = VideoService.get
    @playlists = Playlist.all.pluck(:name, :id)
  end
end
