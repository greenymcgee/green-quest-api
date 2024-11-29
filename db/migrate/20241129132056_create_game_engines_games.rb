class CreateGameEnginesGames < ActiveRecord::Migration[7.2]
  def change
    create_table :game_engines_games do |t|
      t.belongs_to :game_engine
      t.belongs_to :game
      t.timestamps
    end
  end
end
