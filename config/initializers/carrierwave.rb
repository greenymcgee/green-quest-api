CarrierWave.configure do |config|
  config.asset_host = "#{Rails.configuration.app_host_with_protocol}/storage"
  config.root = Rails.root.join("storage")
  config.cache_dir = Rails.root.join("tmp/uploads")
  config.permissions = 0666
  config.directory_permissions = 0755
  config.storage = :file
end
