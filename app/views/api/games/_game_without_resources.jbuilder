json.extract!(
  game,
  :id,
  :igdb_id,
  :name,
  :slug,
  :rating,
  :review,
  :created_at,
  :updated_at,
)
json.published game.published?
