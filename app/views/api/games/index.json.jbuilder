# TODO: figure out how to validate this shape with JSON schemas
# json.array! @games, partial: "api/games/game", as: :game
json.games @games do |game|
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
end
