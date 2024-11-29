json.game_engines do
  json.array!(
    @game_engines,
    partial: "api/game_engines/game_engine",
    as: :game_engine,
  )
end
