# frozen_string_literal: true

class CreatePlaylistSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_songs do |t|
      t.references :playlist, null: false, foreign_key: true
      t.integer :position, null: false
      t.string :video_id, index: true, null: false

      t.timestamps
    end
  end
end
