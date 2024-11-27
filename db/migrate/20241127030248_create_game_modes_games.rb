class CreateGameModesGames < ActiveRecord::Migration[7.2]
  def change
    create_table :game_modes_games do |t|
      t.belongs_to :game_mode
      t.belongs_to :game
      t.timestamps
    end
  end
end
