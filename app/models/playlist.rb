class Playlist < ApplicationRecord
  # TODO: dependent destroy
  has_many :playlist_videos # TODO: Nested?

  validates :name, presence: true, uniqueness: true
end
