class CreateGamesPlatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :games_platforms do |t|
      t.belongs_to :game
      t.belongs_to :platform

      t.timestamps
    end
  end
end
