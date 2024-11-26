class ChangeGamesScreenshotsRelationship < ActiveRecord::Migration[7.2]
  def change
    drop_table :games_screenshots
    add_reference :screenshots, :game
  end
end
