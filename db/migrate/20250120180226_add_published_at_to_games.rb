class AddPublishedAtToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :published_at, :datetime
  end
end
