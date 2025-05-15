class Api::Platforms::CreateFacade
  include IgdbFieldsHelper

  attr_reader :ids
  attr_reader :twitch_bearer_token

  def initialize(ids, twitch_bearer_token)
    @twitch_bearer_token = twitch_bearer_token
    @ids = ids || []
    @errors = { platforms: [], platform_logos: [] }
  end

  def find_or_create_platforms
    { errors: @errors, platforms: platforms }
  end

  private

  def platforms
    ids.map do |id|
      RequestThrottlerRegistry.instance.throttle do
        Platform.find_or_initialize_by(igdb_id: id) do |platform|
          igdb_response = get_platform_igdb_data(id)
          igdb_data = igdb_response[:igdb_data]
          igdb_error = igdb_response[:error]
          next if unprocessable_igdb_response?(id, igdb_data, igdb_error)

          populate_fields(platform, igdb_data)
          set_platform_platform_logo(platform, igdb_data)
          platform.errors.each { |error| @errors[:platforms] << error }
        end
      end
    end
  end

  def unprocessable_igdb_response?(id, data, error)
    add_platform_error(id, error) || data.blank?
  end

  def add_platform_error(id, error)
    return false unless error.present?

    @errors[:platforms] << { id => JSON.parse(error.message) }
  end

  def get_platform_igdb_data(id)
    IgdbRequestFacade.new(
      igdb_id: id,
      pathname: "platforms",
      twitch_bearer_token: twitch_bearer_token,
    ).get_igdb_data
  end

  def populate_fields(platform, igdb_platform_data)
    facade = Api::Platforms::IgdbFieldsFacade.new(platform, igdb_platform_data)
    facade.populate_fields
  end

  def create_platform_logo(id, platform)
    IgdbCreateFacade.new(
      fields_facade: Igdb::ImageFieldsFacade,
      ids: [id],
      model: PlatformLogo,
      twitch_bearer_token: twitch_bearer_token,
    ).find_or_create_resources(platform_logo_callback(platform))
  end

  def platform_logo_callback(platform)
    ->(platform_logo) { platform.platform_logo = platform_logo }
  end

  def set_platform_platform_logo(platform, igdb_data)
    return false unless igdb_data["platform_logo"].present?

    logo_response = create_platform_logo(igdb_data["platform_logo"], platform)
    add_platform_logo_error(logo_response[:errors].first)
  end

  def add_platform_logo_error(error)
    return false unless error.present?

    @errors[:platform_logos] << error
  end
end
