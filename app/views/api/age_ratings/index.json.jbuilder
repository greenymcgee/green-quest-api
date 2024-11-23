json.age_ratings do
  json.array!(
    @age_ratings,
    partial: "api/age_ratings/age_rating",
    as: :age_rating,
  )
end
