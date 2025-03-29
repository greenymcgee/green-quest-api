json.games @games do |game|
  json.extract!(
    game,
    :id,
    :igdb_id,
    :name,
    :slug,
    :rating,
    :review,
    :created_at,
    :updated_at,
  )
  json.cover { json.partial! "api/covers/cover", cover: game.cover }
  json.published game.published?
end
json.total_pages @pagy.pages
