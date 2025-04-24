class AddDatesToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :last_played_date, :date
    add_column :games, :estimated_first_played_date, :date
  end
end
