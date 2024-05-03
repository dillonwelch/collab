# frozen_string_literal: true

class PlaylistVideo < ApplicationRecord
  belongs_to :playlist

  before_create do
    self.position = (playlist.playlist_videos.maximum(:position) || 0) + 1
  end

  validates :video_id, presence: true
  validate :video_id_exists

  validates :position, numericality: { only_integer: true, greater_than: 0, allow_nil: true }

  # Fetches the JSON video information for the video ID assigned to the record.
  # @return [Hash] JSON video information.
  def video
    @video ||= VideoService.get_by_video_id(video_id)
  end

  private

  def video_id_exists
    return unless video_id.present?
    return if video.present?

    errors.add(:video_id, 'must exist')
  end
end
