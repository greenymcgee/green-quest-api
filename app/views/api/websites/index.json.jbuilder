json.websites do
  json.array! @websites, partial: "api/websites/website", as: :website
end
