class AddGameToCovers < ActiveRecord::Migration[7.2]
  def change
    add_reference :covers, :game
  end
end
