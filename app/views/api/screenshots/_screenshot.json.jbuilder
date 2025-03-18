json.extract!(
  screenshot,
  :animated,
  :created_at,
  :height,
  :id,
  :igdb_id,
  :updated_at,
  :width,
)

json.url "https://images.igdb.com/igdb/image/upload/t_720p/#{screenshot.image_id}.webp"
