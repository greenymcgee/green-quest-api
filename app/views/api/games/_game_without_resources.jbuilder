json.extract!(
  game,
  :created_at,
  :currently_playing,
  :estimated_first_played_date,
  :id,
  :igdb_id,
  :last_played_date,
  :name,
  :slug,
  :rating,
  :review,
  :updated_at,
)
json.published game.published?
