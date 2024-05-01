class PlaylistSong < ApplicationRecord
  belongs_to :playlist

  def video
    VideoService.get_by_video_id(video_id)
  end
end
