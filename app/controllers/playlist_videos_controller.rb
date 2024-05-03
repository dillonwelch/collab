# frozen_string_literal: true

require 'net/http'

class PlaylistVideosController < ApplicationController
  protect_from_forgery with: :null_session, only: :swap
  def create
    playlist_video = PlaylistVideo.new(playlist_video_params)
    playlist_video.save!
  end

  def destroy
    playlist_video = PlaylistVideo.find(params[:id])
    playlist_id = playlist_video.playlist_id
    position = playlist_video.position
    playlist_video.destroy
    PlaylistVideo.where(playlist_id:).where('position > ?', position).each do |video|
      video.update(position: video.position - 1)
    end

    redirect_to playlist_path(playlist_id), status: :see_other, notice: 'Playlist entry successfully deleted.'
  end

  def swap
    from_video = PlaylistVideo.find_by_video_id(params[:from_id])
    from_position = from_video.position
    to_video = PlaylistVideo.find_by_video_id(params[:to_id])
    to_position = to_video.position

    from_video.update!(position: to_position)
    to_video.update!(position: from_position)

    head :ok
  end

  private

  def playlist_video_params
    params.require(:playlist_video).permit(:playlist_id, :video_id, :position)
  end
end
