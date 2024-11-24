json.screenshots do
  json.array!(
    @screenshots,
    partial: "api/screenshots/screenshot",
    as: :screenshot,
  )
end
