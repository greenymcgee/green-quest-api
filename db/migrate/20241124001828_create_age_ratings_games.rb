class CreateAgeRatingsGames < ActiveRecord::Migration[7.2]
  def change
    create_table :age_ratings_games do |t|
      t.belongs_to :age_rating
      t.belongs_to :game

      t.timestamps
    end
  end
end
