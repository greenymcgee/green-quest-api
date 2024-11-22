class Api::Platforms::CreateFacade
  include IgdbFieldsHelper

  def initialize(ids, twitch_bearer_token)
    @@twitch_bearer_token = twitch_bearer_token
    @@ids = ids || []
    @@errors = []
  end

  def find_or_create_platforms
    { errors: @@errors, platforms: platforms }
  end

  private

  def platforms
    @@ids.map do |id|
      Platform.find_or_initialize_by(igdb_id: id) do |platform|
        next if platform.id.present?

        platform_request = set_platform_facade(id).get_igdb_platform_data
        if platform_request[:error].present?
          add_platform_error(id, platform_request[:error])
          next
        end

        set_platform_properties(platform, platform_request[:igdb_platform_data])
        platform.save
        platform.errors.each { |error| @@errors << error }
      end
    end
  end

  def add_platform_error(id, error)
    @@errors << { id => JSON.parse(error.message) }
  end

  def set_platform_facade(id)
    Api::Platforms::IgdbRequestFacade.new(id, @@twitch_bearer_token)
  end

  def set_platform_properties(platform, igdb_platform_data)
    facade = Api::Platforms::IgdbFieldsFacade.new(platform, igdb_platform_data)
    facade.populate_platform_fields
  end
end
