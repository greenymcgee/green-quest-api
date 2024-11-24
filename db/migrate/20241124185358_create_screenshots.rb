class CreateScreenshots < ActiveRecord::Migration[7.2]
  def change
    create_table :screenshots do |t|
      t.boolean :alpha_channel, null: false, default: false
      t.boolean :animated, null: false, default: false
      t.string :checksum, null: false, default: ""
      t.integer :height
      t.integer :igdb_id, null: false
      t.string :image_id, null: false, default: ""
      t.string :url, null: false, default: ""
      t.integer :width
      t.timestamps
    end

    add_index :screenshots, :igdb_id, unique: true
  end
end
