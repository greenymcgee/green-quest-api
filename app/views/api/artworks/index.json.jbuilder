json.artworks do
  json.array! @artworks, partial: "api/artworks/artwork", as: :artwork
end
