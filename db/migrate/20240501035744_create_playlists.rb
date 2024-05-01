class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.text :name, index: { unique: true }
      t.timestamps
    end
  end
end
