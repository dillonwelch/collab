class PlaylistVideo < ApplicationRecord
  belongs_to :playlist

  before_create do
    self.position = (playlist.playlist_videos.maximum(:position) || 0) + 1
  end

  # TODO: Validate existence.
  validates :video_id, presence: true

  validates :position, numericality: { only_integer: true, greater_than: 0, allow_nil: true }

  # TODO: how to do validation with edits
  # validates :position, presence: true

  # Fetches the JSON video information for the video ID assigned to the record.
  # @return [Hash] JSON video information.
  def video
    VideoService.get_by_video_id(video_id)
  end
end
