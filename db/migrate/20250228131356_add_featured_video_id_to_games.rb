class AddFeaturedVideoIdToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :featured_video_id, :string, null: false, default: ""
  end
end
