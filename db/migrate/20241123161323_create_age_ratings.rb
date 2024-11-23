class CreateAgeRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :age_ratings do |t|
      t.integer :category_enum
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.integer :rating_enum
      t.string :rating_cover_url, null: false, default: ""
      t.string :synopsis, null: false, default: ""

      t.timestamps
    end

    add_index :age_ratings, :igdb_id, unique: true
  end
end
