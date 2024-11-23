json.errors game.errors if game.errors.present?
json.extract!(
  game,
  :id,
  :igdb_id,
  :name,
  :rating,
  :review,
  :created_at,
  :updated_at,
)
json.developers game.developers do |company|
  json.partial! "api/companies/company", company: company
end
json.genres game.genres do |genre|
  json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
end
json.platforms game.platforms do |platform|
  json.extract!(
    platform,
    :abbreviation,
    :alternative_name,
    :created_at,
    :generation,
    :id,
    :igdb_id,
    :name,
    :slug,
    :summary,
    :updated_at,
  )
end
json.porters game.porters do |company|
  json.partial! "api/companies/company", company: company
end
json.publishers game.publishers do |company|
  json.partial! "api/companies/company", company: company
end
json.supporters game.supporters do |company|
  json.partial! "api/companies/company", company: company
end
