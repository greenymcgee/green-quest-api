class CreateGamesThemes < ActiveRecord::Migration[7.2]
  def change
    create_table :games_themes do |t|
      t.belongs_to :theme
      t.belongs_to :game
      t.timestamps
    end
  end
end
