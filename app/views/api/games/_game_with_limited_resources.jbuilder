json.extract!(
  game,
  :created_at,
  :currently_playing,
  :estimated_first_played_date,
  :first_release_date,
  :id,
  :igdb_id,
  :last_played_date,
  :name,
  :slug,
  :rating,
  :review,
  :updated_at,
)
json.cover { json.partial! "api/covers/cover", cover: game.cover }
json.platforms game.platforms do |platform|
  json.partial! "api/platforms/platform_without_resources", platform: platform
end
json.published game.published?
