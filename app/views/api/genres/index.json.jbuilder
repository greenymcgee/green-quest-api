json.genres @genres do |genre|
  json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
end
