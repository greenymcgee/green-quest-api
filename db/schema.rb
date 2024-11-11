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

ActiveRecord::Schema[7.2].define(version: 2024_11_09_210238) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer "age_rating_ids", default: [], array: true
    t.integer "alternative_name_ids", default: [], array: true
    t.integer "artwork_ids", default: [], array: true
    t.integer "bundle_ids", default: [], array: true
    t.string "category_enum", default: ""
    t.string "checksum", default: ""
    t.integer "collection_id", default: 0
    t.integer "collection_ids", default: [], array: true
    t.integer "cover_id", default: 0
    t.integer "dlc_ids", default: [], array: true
    t.integer "expanded_game_ids", default: [], array: true
    t.integer "expansion_ids", default: [], array: true
    t.integer "external_game_ids", default: [], array: true
    t.datetime "first_release_date"
    t.integer "fork_ids", default: [], array: true
    t.integer "franchise_id", default: 0
    t.integer "franchise_ids", default: [], array: true
    t.integer "game_engine_ids", default: [], array: true
    t.integer "game_localization_ids", default: [], array: true
    t.integer "game_mode_ids", default: [], array: true
    t.integer "genre_ids", default: [], array: true
    t.integer "igdb_id"
    t.string "igdb_url", default: ""
    t.integer "involved_company_ids", default: [], array: true
    t.integer "keyword_ids", default: [], array: true
    t.integer "language_support_ids", default: [], array: true
    t.integer "multiplayer_mode_ids", default: [], array: true
    t.string "name", default: ""
    t.integer "parent_game_id", default: 0
    t.integer "platform_ids", default: [], array: true
    t.integer "player_perspective_ids", default: [], array: true
    t.integer "port_ids", default: [], array: true
    t.float "rating", default: 0.0
    t.integer "release_date_ids", default: [], array: true
    t.integer "remake_ids", default: [], array: true
    t.integer "remaster_ids", default: [], array: true
    t.text "review", default: ""
    t.integer "screenshot_ids", default: [], array: true
    t.integer "similar_game_ids", default: [], array: true
    t.string "slug", default: ""
    t.integer "standalone_expansion_ids", default: [], array: true
    t.string "status", default: ""
    t.string "storyline", default: ""
    t.string "summary", default: ""
    t.integer "tag_ids", default: [], array: true
    t.integer "theme_ids", default: [], array: true
    t.integer "version_parent_id", default: 0
    t.string "version_title", default: ""
    t.integer "video_ids", default: [], array: true
    t.integer "website_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "index_games_on_igdb_id", unique: true
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
end
