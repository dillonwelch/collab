# frozen_string_literal: true

class RenamePlaylistSongToPlaylistVideo < ActiveRecord::Migration[7.1]
  def change
    rename_table :playlist_songs, :playlist_videos
  end
end
