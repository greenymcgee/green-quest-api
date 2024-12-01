json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
json.games genre.games do |game|
  json.partial! "api/games/game_without_resources", game: game
end
