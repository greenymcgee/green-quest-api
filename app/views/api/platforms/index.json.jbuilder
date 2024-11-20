json.platforms @platforms do |platform|
  json.partial! "api/platforms/platform", platform: platform
end
