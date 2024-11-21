class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.datetime :change_date
      t.integer :change_date_category_enum
      t.integer :changed_company_id
      t.string :checksum, null: false, default: ""
      t.integer :country_code
      t.string :description, null: false, default: ""
      t.integer :developed_games, array: true, default: [], null: false
      t.integer :igdb_id, null: false
      t.string :igdb_url, null: false, default: ""
      t.string :name, null: false, default: ""
      t.integer :parent_id
      t.integer :published_games, array: true, default: [], null: false
      t.string :slug, null: false, default: ""
      t.datetime :start_date

      t.timestamps
    end

    add_index :companies, :igdb_id, unique: true
    add_index :companies, :slug
  end
end
