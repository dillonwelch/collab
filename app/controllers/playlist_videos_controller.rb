require "net/http"

class PlaylistVideosController < ApplicationController
  def create
    @playlist_video = PlaylistVideo.new(playlist_video_params)
    @playlist_video.save
  end

  private

  def playlist_video_params
    params.require(:playlist_video).permit(:playlist_id, :video_id, :position)
  end
end