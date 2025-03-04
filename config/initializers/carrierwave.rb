CarrierWave.configure do |config|
  config.asset_host = Rails.application.routes.default_url_options[:host]
  config.permissions = 0666
  config.directory_permissions = 0755
  config.storage = :file
end
