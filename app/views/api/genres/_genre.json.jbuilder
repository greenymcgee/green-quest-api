json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
json.games genre.games do |game|
  json.extract! game, :created_at, :id, :igdb_id, :name, :rating, :updated_at
end
