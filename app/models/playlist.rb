# frozen_string_literal: true

class Playlist < ApplicationRecord
  has_many :playlist_videos, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
