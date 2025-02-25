class AddGameVideosGameReference < ActiveRecord::Migration[8.0]
  def change
    add_reference :game_videos, :game
  end
end
