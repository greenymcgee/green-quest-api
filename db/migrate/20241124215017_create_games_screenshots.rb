class CreateGamesScreenshots < ActiveRecord::Migration[7.2]
  def change
    create_table :games_screenshots do |t|
      t.belongs_to :game
      t.belongs_to :screenshot
      t.timestamps
    end
  end
end
