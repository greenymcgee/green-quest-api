json.partial! "api/platforms/platform_without_resources", platform: platform
json.games platform.games do |game|
  json.partial! "api/games/game_without_resources", game: game
end
