require "net/http"

# TODO: songs to videos qq
class PlaylistSongsController < ApplicationController
  def create
    @playlist_song = PlaylistSong.new(playlist_song_params)
    # @playlist_song.position = 1
    @playlist_song.save
    # puts playlist_song_params
    # puts "valid? #{@playlist_song.valid?}"
  end

  private

  def playlist_song_params
    params.require(:playlist_song).permit(:playlist_id, :video_id, :position)
  end
end
