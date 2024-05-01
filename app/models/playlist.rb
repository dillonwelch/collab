class Playlist < ApplicationRecord
  has_many :playlist_songs

  validates :name, presence: true, uniqueness: true
end
