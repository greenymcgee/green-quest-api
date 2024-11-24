json.release_dates do
  json.array!(
    @release_dates,
    partial: "api/release_dates/release_date",
    as: :release_date,
  )
end
