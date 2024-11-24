class CreateArtworksGames < ActiveRecord::Migration[7.2]
  def change
    create_table :artworks_games do |t|
      t.belongs_to :artwork
      t.belongs_to :game

      t.timestamps
    end
  end
end
