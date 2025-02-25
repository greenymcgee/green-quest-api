class CreateGameVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :game_videos do |t|
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.string :name, null: false, default: ""
      t.string :video_id, null: false, default: ""
      t.timestamps
    end

    add_index :game_videos, :igdb_id, unique: true
  end
end
