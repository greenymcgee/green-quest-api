json.player_perspectives do
  json.array!(
    @player_perspectives,
    partial: "api/player_perspectives/player_perspective",
    as: :player_perspective,
  )
end
