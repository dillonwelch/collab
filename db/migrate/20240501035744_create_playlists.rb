class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.text :name, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
