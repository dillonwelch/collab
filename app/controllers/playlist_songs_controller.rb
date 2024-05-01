require "net/http"

# TODO: songs to videos qq
class PlaylistSongsController < ApplicationController
  def create
    @playlist_song = PlaylistSong.new(playlist_song_params)
  end

  private

  def playlist_song_params
    params.permit(:playlist_id, :video_id, :position)
  end
end
