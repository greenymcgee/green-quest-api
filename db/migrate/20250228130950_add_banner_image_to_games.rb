class AddBannerImageToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :banner_image, :string
  end
end
