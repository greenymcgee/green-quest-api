# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_25_130941) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "age_ratings", force: :cascade do |t|
    t.integer "category_enum"
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.integer "rating_enum"
    t.string "rating_cover_url", default: "", null: false
    t.string "synopsis", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_age_ratings_on_igdb_id", unique: true
  end

  create_table "age_ratings_games", force: :cascade do |t|
    t.bigint "age_rating_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_rating_id"], name: "index_age_ratings_games_on_age_rating_id"
    t.index ["game_id"], name: "index_age_ratings_games_on_game_id"
  end

  create_table "artworks", force: :cascade do |t|
    t.boolean "alpha_channel", default: false, null: false
    t.boolean "animated", default: false, null: false
    t.string "checksum", default: "", null: false
    t.integer "height"
    t.integer "igdb_id", null: false
    t.string "image_id", default: "", null: false
    t.string "url", default: "", null: false
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_artworks_on_game_id"
    t.index ["igdb_id"], name: "index_artworks_on_igdb_id", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "change_date"
    t.integer "change_date_category_enum"
    t.integer "changed_company_id"
    t.string "checksum", default: "", null: false
    t.integer "country_code"
    t.string "description", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "parent_id"
    t.string "slug", default: "", null: false
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "developed_game_ids", default: [], null: false, array: true
    t.integer "published_game_ids", default: [], null: false, array: true
    t.index ["igdb_id"], name: "index_companies_on_igdb_id", unique: true
    t.index ["slug"], name: "index_companies_on_slug"
  end

  create_table "company_logos", force: :cascade do |t|
    t.boolean "alpha_channel", default: false, null: false
    t.boolean "animated", default: false, null: false
    t.string "checksum", default: "", null: false
    t.integer "height"
    t.integer "igdb_id", null: false
    t.string "image_id", default: "", null: false
    t.string "url", default: "", null: false
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_company_logos_on_company_id"
    t.index ["igdb_id"], name: "index_company_logos_on_igdb_id", unique: true
  end

  create_table "covers", force: :cascade do |t|
    t.boolean "alpha_channel", default: false, null: false
    t.boolean "animated", default: false, null: false
    t.string "checksum", default: "", null: false
    t.integer "height"
    t.integer "igdb_id", null: false
    t.string "image_id", default: "", null: false
    t.string "url", default: "", null: false
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_covers_on_game_id"
    t.index ["igdb_id"], name: "index_covers_on_igdb_id", unique: true
  end

  create_table "franchises", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.boolean "main", default: false, null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_franchises_on_igdb_id", unique: true
    t.index ["slug"], name: "index_franchises_on_slug"
  end

  create_table "franchises_games", force: :cascade do |t|
    t.bigint "franchise_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_franchises_games_on_franchise_id"
    t.index ["game_id"], name: "index_franchises_games_on_game_id"
  end

  create_table "game_engine_logos", force: :cascade do |t|
    t.boolean "alpha_channel", default: false, null: false
    t.boolean "animated", default: false, null: false
    t.string "checksum", default: "", null: false
    t.integer "height"
    t.integer "igdb_id", null: false
    t.string "image_id", default: "", null: false
    t.string "url", default: "", null: false
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_engine_id"
    t.index ["game_engine_id"], name: "index_game_engine_logos_on_game_engine_id"
    t.index ["igdb_id"], name: "index_game_engine_logos_on_igdb_id", unique: true
  end

  create_table "game_engines", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "description", default: "", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_game_engines_on_igdb_id", unique: true
    t.index ["slug"], name: "index_game_engines_on_slug"
  end

  create_table "game_engines_games", force: :cascade do |t|
    t.bigint "game_engine_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_engine_id"], name: "index_game_engines_games_on_game_engine_id"
    t.index ["game_id"], name: "index_game_engines_games_on_game_id"
  end

  create_table "game_modes", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_game_modes_on_igdb_id", unique: true
    t.index ["slug"], name: "index_game_modes_on_slug"
  end

  create_table "game_modes_games", force: :cascade do |t|
    t.bigint "game_mode_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_modes_games_on_game_id"
    t.index ["game_mode_id"], name: "index_game_modes_games_on_game_mode_id"
  end

  create_table "game_videos", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "name", default: "", null: false
    t.string "video_id", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_game_videos_on_game_id"
    t.index ["igdb_id"], name: "index_game_videos_on_igdb_id", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.datetime "first_release_date"
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.float "rating", default: 0.0
    t.text "review", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "status", default: "", null: false
    t.string "storyline", default: "", null: false
    t.string "summary", default: "", null: false
    t.string "version_title", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_enum"
    t.integer "bundle_ids", default: [], null: false, array: true
    t.integer "dlc_ids", default: [], null: false, array: true
    t.integer "expanded_game_ids", default: [], null: false, array: true
    t.integer "expansion_ids", default: [], null: false, array: true
    t.integer "fork_ids", default: [], null: false, array: true
    t.integer "parent_game_id"
    t.integer "port_ids", default: [], null: false, array: true
    t.integer "remake_ids", default: [], null: false, array: true
    t.integer "remaster_ids", default: [], null: false, array: true
    t.integer "similar_game_ids", default: [], null: false, array: true
    t.integer "standalone_expansion_ids", default: [], null: false, array: true
    t.integer "version_parent_id"
    t.integer "main_franchise_id"
    t.datetime "published_at"
    t.index ["igdb_id"], name: "index_games_on_igdb_id", unique: true
    t.index ["slug"], name: "index_games_on_slug"
  end

  create_table "games_genres", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_genres_on_game_id"
    t.index ["genre_id"], name: "index_games_genres_on_genre_id"
  end

  create_table "games_platforms", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "platform_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_platforms_on_game_id"
    t.index ["platform_id"], name: "index_games_platforms_on_platform_id"
  end

  create_table "games_player_perspectives", force: :cascade do |t|
    t.bigint "player_perspective_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_player_perspectives_on_game_id"
    t.index ["player_perspective_id"], name: "index_games_player_perspectives_on_player_perspective_id"
  end

  create_table "games_themes", force: :cascade do |t|
    t.bigint "theme_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_themes_on_game_id"
    t.index ["theme_id"], name: "index_games_themes_on_theme_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_genres_on_igdb_id", unique: true
    t.index ["slug"], name: "index_genres_on_slug"
  end

  create_table "involved_companies", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.bigint "company_id"
    t.bigint "game_id"
    t.integer "igdb_id", null: false
    t.boolean "is_developer", default: false, null: false
    t.boolean "is_porter", default: false, null: false
    t.boolean "is_publisher", default: false, null: false
    t.boolean "is_supporter", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_involved_companies_on_company_id"
    t.index ["game_id"], name: "index_involved_companies_on_game_id"
    t.index ["igdb_id"], name: "index_involved_companies_on_igdb_id", unique: true
  end

  create_table "platform_logos", force: :cascade do |t|
    t.boolean "alpha_channel", default: false, null: false
    t.boolean "animated", default: false, null: false
    t.string "checksum", default: "", null: false
    t.integer "height"
    t.integer "igdb_id", null: false
    t.string "image_id", default: "", null: false
    t.string "url", default: "", null: false
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "platform_id"
    t.index ["igdb_id"], name: "index_platform_logos_on_igdb_id", unique: true
    t.index ["platform_id"], name: "index_platform_logos_on_platform_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "abbreviation", default: "", null: false
    t.string "alternative_name", default: "", null: false
    t.integer "category_enum"
    t.string "checksum", default: "", null: false
    t.integer "generation"
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "summary", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_platforms_on_igdb_id", unique: true
    t.index ["slug"], name: "index_platforms_on_slug"
  end

  create_table "player_perspectives", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_player_perspectives_on_igdb_id", unique: true
    t.index ["slug"], name: "index_player_perspectives_on_slug"
  end

  create_table "release_dates", force: :cascade do |t|
    t.integer "category_enum"
    t.string "checksum", default: "", null: false
    t.datetime "date"
    t.integer "igdb_id", null: false
    t.string "human_readable", default: "", null: false
    t.integer "month"
    t.integer "region_enum"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "platform_id"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_release_dates_on_game_id"
    t.index ["igdb_id"], name: "index_release_dates_on_igdb_id", unique: true
    t.index ["platform_id"], name: "index_release_dates_on_platform_id"
  end

  create_table "screenshots", force: :cascade do |t|
    t.boolean "alpha_channel", default: false, null: false
    t.boolean "animated", default: false, null: false
    t.string "checksum", default: "", null: false
    t.integer "height"
    t.integer "igdb_id", null: false
    t.string "image_id", default: "", null: false
    t.string "url", default: "", null: false
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_screenshots_on_game_id"
    t.index ["igdb_id"], name: "index_screenshots_on_igdb_id", unique: true
  end

  create_table "themes", force: :cascade do |t|
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.string "igdb_url", default: "", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_themes_on_igdb_id", unique: true
    t.index ["slug"], name: "index_themes_on_slug"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "jti", default: "", null: false
    t.string "roles", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "websites", force: :cascade do |t|
    t.integer "category_enum"
    t.string "checksum", default: "", null: false
    t.integer "igdb_id", null: false
    t.boolean "trusted", default: false, null: false
    t.string "url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_websites_on_game_id"
    t.index ["igdb_id"], name: "index_websites_on_igdb_id", unique: true
  end
end
