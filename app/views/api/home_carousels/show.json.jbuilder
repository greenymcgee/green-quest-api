json.carousel do
  json.games @games do |game|
    json.partial! "api/games/game_with_limited_resources", game: game
  end
end
