class AddMainFranchiseIdToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :main_franchise_id, :integer
  end
end
