class CreateGames < ActiveRecord::Migration[7.2]
  def up
    create_table :games do |t|
      t.integer :age_rating_ids, array: true, default: []
      t.integer :alternative_name_ids, array: true, default: []
      t.integer :artwork_ids, array: true, default: []
      t.integer :bundle_ids, array: true, default: []
      t.string :category_enum, default: ""
      t.string :checksum, default: ""
      t.integer :collection_id, default: 0
      t.integer :collection_ids, array: true, default: []
      t.integer :cover_id, default: 0
      t.integer :dlc_ids, array: true, default: []
      t.integer :expanded_game_ids, array: true, default: []
      t.integer :expansion_ids, array: true, default: []
      t.integer :external_game_ids, array: true, default: []
      t.datetime :first_release_date, default: ""
      t.integer :fork_ids, array: true, default: []
      t.integer :franchise_id, default: 0
      t.integer :franchise_ids, array: true, default: []
      t.integer :game_engine_ids, array: true, default: []
      t.integer :game_localization_ids, array: true, default: []
      t.integer :game_mode_ids, array: true, default: []
      t.integer :genre_ids, array: true, default: []
      t.integer :igdb_id
      t.string :igdb_url, default: ""
      t.integer :involved_company_ids, array: true, default: []
      t.integer :keyword_ids, array: true, default: []
      t.integer :language_support_ids, array: true, default: []
      t.integer :multiplayer_mode_ids, array: true, default: []
      t.string :name, default: ""
      t.integer :parent_game_id, default: 0
      t.integer :platform_ids, array: true, default: []
      t.integer :player_perspective_ids, array: true, default: []
      t.integer :port_ids, array: true, default: []
      t.float :rating, default: 0
      t.integer :release_date_ids, array: true, default: []
      t.integer :remake_ids, array: true, default: []
      t.integer :remaster_ids, array: true, default: []
      t.text :review, default: ""
      t.integer :screenshot_ids, array: true, default: []
      t.integer :similar_game_ids, array: true, default: []
      t.string :slug, default: ""
      t.integer :standalone_expansion_ids, array: true, default: []
      t.string :status, default: ""
      t.string :storyline, default: ""
      t.string :summary, default: ""
      t.integer :tag_ids, array: true, default: []
      t.integer :theme_ids, array: true, default: []
      t.integer :version_parent_id, default: 0
      t.string :version_title, default: ""
      t.integer :video_ids, array: true, default: []
      t.integer :website_ids, array: true, default: []

      t.timestamps
    end

    add_index :games, :igdb_id, unique: true
  end

  def down
    drop_table :games
  end
end
