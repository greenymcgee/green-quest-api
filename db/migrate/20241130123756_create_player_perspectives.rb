class CreatePlayerPerspectives < ActiveRecord::Migration[7.2]
  def change
    create_table :player_perspectives do |t|
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: ""

      t.timestamps
    end

    add_index :player_perspectives, :igdb_id, unique: true
  end
end
