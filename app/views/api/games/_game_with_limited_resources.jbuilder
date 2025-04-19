json.extract!(
  game,
  :first_release_date,
  :id,
  :igdb_id,
  :name,
  :slug,
  :rating,
  :review,
  :created_at,
  :updated_at,
)
json.cover { json.partial! "api/covers/cover", cover: game.cover }
json.platforms game.platforms do |platform|
  json.partial! "api/platforms/platform_without_resources", platform: platform
end
json.published game.published?
