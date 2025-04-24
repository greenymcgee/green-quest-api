json.extract!(
  game,
  :created_at,
  :currently_playing,
  :id,
  :igdb_id,
  :name,
  :slug,
  :rating,
  :review,
  :updated_at,
)
json.published game.published?
