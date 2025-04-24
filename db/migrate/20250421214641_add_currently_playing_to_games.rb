class AddCurrentlyPlayingToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :currently_playing, :boolean, default: false, null: false
  end
end
