class Playlist < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
