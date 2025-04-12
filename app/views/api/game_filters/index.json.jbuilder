json.filters do
  json.companies @companies do |company|
    json.partial! "api/companies/company", company: company
  end

  json.genres @genres do |genre|
    json.extract! genre, :id, :igdb_id, :name, :slug, :created_at, :updated_at
  end

  json.platforms @platforms do |platform|
    json.partial! "api/platforms/platform_without_resources", platform: platform
  end
end
