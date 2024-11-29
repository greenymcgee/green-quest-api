class CreateFranchises < ActiveRecord::Migration[7.2]
  def change
    create_table :franchises do |t|
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.boolean :main, null: false, default: false
      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: ""

      t.timestamps
    end

    add_index :franchises, :igdb_id, unique: true
  end
end
