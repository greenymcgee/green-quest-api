json.errors game.errors if game.errors.present?
json.extract!(
  game,
  :id,
  :igdb_id,
  :name,
  :rating,
  :review,
  :created_at,
  :updated_at,
)
json.age_ratings game.age_ratings do |age_rating|
  json.partial! "api/age_ratings/age_rating", age_rating: age_rating
end
json.artworks game.artworks do |artwork|
  json.partial! "api/artworks/artwork", artwork: artwork
end
json.cover { json.partial! "api/covers/cover", cover: @game.cover }
json.developers game.developers do |company|
  json.partial! "api/companies/company", company: company
end
json.game_engines game.game_engines do |game_engine|
  json.partial! "api/game_engines/game_engine", game_engine: game_engine
end
json.game_modes game.game_modes do |game_mode|
  json.partial! "api/game_modes/game_mode", game_mode: game_mode
end
json.genres game.genres do |genre|
  json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
end
json.platforms game.platforms do |platform|
  json.extract!(
    platform,
    :abbreviation,
    :alternative_name,
    :created_at,
    :generation,
    :id,
    :igdb_id,
    :name,
    :slug,
    :summary,
    :updated_at,
  )
end
json.porters game.porters do |company|
  json.partial! "api/companies/company", company: company
end
json.publishers game.publishers do |company|
  json.partial! "api/companies/company", company: company
end
json.release_dates game.release_dates.includes([:platform]) do |release_date|
  json.partial! "api/release_dates/release_date", release_date: release_date
end
json.screenshots game.screenshots do |screenshot|
  json.partial! "api/screenshots/screenshot", screenshot: screenshot
end
json.supporters game.supporters do |company|
  json.partial! "api/companies/company", company: company
end
json.websites game.websites do |website|
  json.partial! "api/websites/website", website: website
end
