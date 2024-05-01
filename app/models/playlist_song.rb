class PlaylistSong < ApplicationRecord
  belongs_to :playlist

  before_create do
    self.position = (playlist.playlist_songs.maximum(:position) || 0) + 1
  end

  def video
    VideoService.get_by_video_id(video_id)
  end
end
