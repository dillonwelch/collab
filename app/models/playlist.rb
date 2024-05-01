class Playlist < ApplicationRecord
  has_many :playlist_songs # TODO: Nested?

  validates :name, presence: true, uniqueness: true
end
