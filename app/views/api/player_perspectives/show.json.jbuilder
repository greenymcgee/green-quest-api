json.player_perspective do
  json.partial!(
    "api/player_perspectives/player_perspective",
    player_perspective: @player_perspective,
  )
end
