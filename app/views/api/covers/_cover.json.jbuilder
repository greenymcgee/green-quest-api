json.extract!(
  cover,
  :animated,
  :created_at,
  :height,
  :id,
  :igdb_id,
  :image_id,
  :updated_at,
  :width,
)
json.url "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/#{cover.image_id}.webp"
