class CreateGameEngines < ActiveRecord::Migration[7.2]
  def change
    create_table :game_engines do |t|
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.string :description, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: ""

      t.timestamps
    end

    add_index :game_engines, :igdb_id, unique: true
  end
end
