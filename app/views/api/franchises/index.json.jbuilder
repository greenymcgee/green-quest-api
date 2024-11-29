json.franchises do
  json.array! @franchises, partial: "api/franchises/franchise", as: :franchise
end
