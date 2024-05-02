require "net/http"

class PlaylistVideosController < ApplicationController
  def create
    # TODO: proper error response
    # TODO: flash messages
    @playlist_video = PlaylistVideo.new(playlist_video_params)
    @playlist_video.save!
  end

  # TODO: test
  def destroy
    playlist_video = PlaylistVideo.find(params[:id])
    playlist_id = playlist_video.playlist_id
    playlist_video.destroy

    redirect_to playlist_path(playlist_id), status: :see_other, notice: "Playlist entry successfully deleted."
  end
  # TODO: Edit and reorder

  private

  def playlist_video_params
    params.require(:playlist_video).permit(:playlist_id, :video_id, :position)
  end
end
