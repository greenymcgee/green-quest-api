class CreatePlatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :platforms do |t|
      t.string :abbreviation, null: false, default: ""
      t.string :alternative_name, null: false, default: ""
      t.integer :category_enum
      t.string :checksum, null: false, default: ""
      t.integer :generation
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: ""
      t.string :summary, null: false, default: ""

      t.timestamps
    end

    add_index :platforms, :igdb_id, unique: true
    add_index :platforms, :slug
  end
end
