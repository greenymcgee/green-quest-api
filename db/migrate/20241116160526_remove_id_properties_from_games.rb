class RemoveIdPropertiesFromGames < ActiveRecord::Migration[7.2]
  def change
    remove_column :games, :age_rating_ids
    remove_column :games, :alternative_name_ids
    remove_column :games, :artwork_ids
    remove_column :games, :bundle_ids
    remove_column :games, :collection_id
    remove_column :games, :collection_ids
    remove_column :games, :cover_id
    remove_column :games, :dlc_ids
    remove_column :games, :expanded_game_ids
    remove_column :games, :expansion_ids
    remove_column :games, :external_game_ids
    remove_column :games, :fork_ids
    remove_column :games, :franchise_id
    remove_column :games, :franchise_ids
    remove_column :games, :game_engine_ids
    remove_column :games, :game_localization_ids
    remove_column :games, :game_mode_ids
    remove_column :games, :genre_ids
    remove_column :games, :involved_company_ids
    remove_column :games, :keyword_ids
    remove_column :games, :language_support_ids
    remove_column :games, :multiplayer_mode_ids
    remove_column :games, :parent_game_id
    remove_column :games, :platform_ids
    remove_column :games, :player_perspective_ids
    remove_column :games, :port_ids
    remove_column :games, :release_date_ids
    remove_column :games, :remake_ids
    remove_column :games, :remaster_ids
    remove_column :games, :screenshot_ids
    remove_column :games, :similar_game_ids
    remove_column :games, :standalone_expansion_ids
    remove_column :games, :tag_ids
    remove_column :games, :theme_ids
    remove_column :games, :version_parent_id
    remove_column :games, :video_ids
    remove_column :games, :website_ids
  end
end
