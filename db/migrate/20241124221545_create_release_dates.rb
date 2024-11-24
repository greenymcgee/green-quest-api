class CreateReleaseDates < ActiveRecord::Migration[7.2]
  def change
    create_table :release_dates do |t|
      t.integer :category_enum
      t.string :checksum, null: false, default: ""
      t.datetime :date
      t.integer :igdb_id, null: false
      t.string :human_readable, null: false, default: ""
      t.integer :month
      t.integer :region_enum
      t.integer :year

      t.timestamps
    end

    add_index :release_dates, :igdb_id, unique: true
  end
end
