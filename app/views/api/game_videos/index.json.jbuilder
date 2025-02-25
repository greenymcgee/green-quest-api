json.game_videos do
  json.array!(
    @game_videos,
    partial: "api/game_videos/game_video",
    as: :game_video,
  )
end
