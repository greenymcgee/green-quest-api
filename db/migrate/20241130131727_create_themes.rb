class CreateThemes < ActiveRecord::Migration[7.2]
  def change
    create_table :themes do |t|
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: ""

      t.timestamps
    end

    add_index :themes, :igdb_id, unique: true
    add_index :themes, :slug
    add_index :franchises, :slug
    add_index :player_perspectives, :slug
    add_index :game_engines, :slug
  end
end