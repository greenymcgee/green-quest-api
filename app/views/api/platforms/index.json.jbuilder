json.platforms @platforms do |platform|
  json.partial! "api/platforms/platform_without_resources", platform: platform
end
