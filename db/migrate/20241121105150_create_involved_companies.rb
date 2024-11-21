class CreateInvolvedCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :involved_companies do |t|
      t.string :checksum, default: "", null: false
      t.belongs_to :company
      t.belongs_to :game
      t.integer :igdb_id, null: false
      t.boolean :is_developer, null: false, default: false
      t.boolean :is_porter, null: false, default: false
      t.boolean :is_publisher, null: false, default: false
      t.boolean :is_supporter, null: false, default: false

      t.timestamps
    end

    add_index :involved_companies, :igdb_id, unique: true
  end
end
