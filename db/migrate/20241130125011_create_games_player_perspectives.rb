class CreateGamesPlayerPerspectives < ActiveRecord::Migration[7.2]
  def change
    create_table :games_player_perspectives do |t|
      t.belongs_to :player_perspective
      t.belongs_to :game
      t.timestamps
    end
  end
end
