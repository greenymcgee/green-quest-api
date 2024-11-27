json.platform_logos do
  json.array!(
    @platform_logos,
    partial: "api/platform_logos/platform_logo",
    as: :platform_logo,
  )
end
