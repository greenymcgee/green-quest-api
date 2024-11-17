class CreateGamesGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :games_genres do |t|
      t.belongs_to :game
      t.belongs_to :genre

      t.timestamps
    end
  end
end
