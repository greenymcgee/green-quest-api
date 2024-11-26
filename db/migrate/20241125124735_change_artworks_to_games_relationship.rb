class ChangeArtworksToGamesRelationship < ActiveRecord::Migration[7.2]
  def change
    drop_table :artworks_games
    add_reference :artworks, :game
  end
end
