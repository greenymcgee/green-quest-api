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
json.genres game.genres do |genre|
  json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
end
json.errors game.errors if game.errors.present?
