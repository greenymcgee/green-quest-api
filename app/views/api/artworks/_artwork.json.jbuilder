json.extract!(
  artwork,
  :animated,
  :created_at,
  :height,
  :id,
  :igdb_id,
  :updated_at,
  :width,
)

json.url "https://images.igdb.com/igdb/image/upload/t_720p/#{artwork.image_id}.webp"
