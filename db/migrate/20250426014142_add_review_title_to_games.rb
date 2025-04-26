class AddReviewTitleToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :review_title, :string, null: false, default: ""
  end
end
