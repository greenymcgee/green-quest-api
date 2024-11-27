class CreateWebsites < ActiveRecord::Migration[7.2]
  def change
    create_table :websites do |t|
      t.integer :category_enum
      t.string :checksum, null: false, default: ""
      t.integer :igdb_id, null: false
      t.boolean :trusted, null: false, default: false
      t.string :url, null: false, default: ""

      t.timestamps
    end

    add_index :websites, :igdb_id, unique: true
  end
end
