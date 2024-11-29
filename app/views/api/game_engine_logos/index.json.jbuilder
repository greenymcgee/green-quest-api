json.game_engine_logos do
  json.array!(
    @game_engine_logos,
    partial: "api/game_engine_logos/game_engine_logo",
    as: :game_engine_logo,
  )
end
