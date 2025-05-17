class Api::Platforms::RefreshFacade < Api::Platforms::CreateFacade
  def platforms
    ids.map do |id|
      RequestThrottlerRegistry.instance.throttle do
        platform = Platform.find_or_initialize_by(igdb_id: id)
        igdb_response = get_platform_igdb_data(id)
        igdb_data = igdb_response[:igdb_data]
        igdb_error = igdb_response[:error]
        next platform if unprocessable_igdb_response?(id, igdb_data, igdb_error)

        populate_fields(platform, igdb_data)
        platform.save
        set_platform_platform_logo(platform, igdb_data)
        platform.errors.each { |error| @errors[:platforms] << error }
        platform
      end
    end
  end

  def create_platform_logo(id, platform)
    IgdbRefreshFacade.new(
      fields_facade: Igdb::ImageFieldsFacade,
      ids: [id],
      model: PlatformLogo,
      twitch_bearer_token: twitch_bearer_token,
    ).find_or_create_resources(platform_logo_callback(platform))
  end
end
