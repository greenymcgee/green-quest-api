# TODO: figure out how to validate this shape with JSON schemas
# json.array! @games, partial: "api/games/game", as: :game
json.games @games do |game|
  json.partial! "api/games/game", game: game
end
