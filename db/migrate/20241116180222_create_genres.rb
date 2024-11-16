class CreateGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :genres do |t|
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: ""

      t.timestamps
    end

    add_index :genres, :igdb_id, unique: true
    add_index :genres, :slug
  end
end
