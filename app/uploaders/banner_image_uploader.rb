# CHange this to BannerImageUploader
# Figure out full urls for frontend
# Send the image to the frontend
# Change the migration to game.banner_image
# Add migration for featured_video_id
# Configure default values of all inputs in edit page
# Update the jbuilder to send new attributes
class BannerImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Rails.application.routes.url_helpers

  process resize_to_fill: [1200, 400]
  process convert: "webp"

  version :mobile do
    process resize_to_fill: [420, 140]
    process convert: "webp"
  end

  storage :file

  def asset_host
    Rails.application.routes.default_url_options[:host]
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg"
  # end
end
