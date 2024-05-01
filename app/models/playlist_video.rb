class PlaylistVideo < ApplicationRecord
  belongs_to :playlist

  before_create do
    self.position = (playlist.playlist_videos.maximum(:position) || 0) + 1
  end

  validates :video_id, presence: true
  # validates :position, presence: true

  def video
    VideoService.get_by_video_id(video_id)
  end
end
