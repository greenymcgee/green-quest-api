json.game_modes do
  json.array! @game_modes, partial: "api/game_modes/game_mode", as: :game_mode
end
