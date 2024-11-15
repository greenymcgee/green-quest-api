class AddIndexOnGameSlugs < ActiveRecord::Migration[7.2]
  def change
    add_index :games, :slug
  end
end
