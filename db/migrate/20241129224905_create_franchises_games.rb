class CreateFranchisesGames < ActiveRecord::Migration[7.2]
  def change
    create_table :franchises_games do |t|
      t.belongs_to :franchise
      t.belongs_to :game
      t.timestamps
    end
  end
end
