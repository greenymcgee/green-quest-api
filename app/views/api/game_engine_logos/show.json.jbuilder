json.game_engine_logo do
  json.partial!(
    "api/game_engine_logos/game_engine_logo",
    game_engine_logo: @game_engine_logo,
  )
end
