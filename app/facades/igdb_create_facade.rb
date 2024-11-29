class IgdbCreateFacade
  def initialize(fields_facade:, ids:, model:, twitch_bearer_token:)
    @@errors = []
    @@fields_facade = fields_facade
    @@ids = ids || []
    @@model = model
    @@twitch_bearer_token = twitch_bearer_token
  end

  def find_or_create_resources(callback = nil)
    { errors: @@errors, resources: resources(callback) }
  end

  private

  def resources(callback)
    @@ids.map do |id|
      @@model.find_or_initialize_by(igdb_id: id) do |resource|
        igdb_response = get_igdb_data(id)
        igdb_data = igdb_response[:igdb_data]
        next if add_igdb_error(id, igdb_response[:error]) || igdb_data.blank?

        callback.call(resource) if callback.present?
        populate_resource_fields(resource, igdb_data)
        resource.errors.each { |error| @@errors << error }
      end
    end
  end

  def add_igdb_error(id, error)
    return false unless error.present?

    @@errors << { id => JSON.parse(error.message) }
  end

  def get_igdb_data(id)
    facade =
      IgdbRequestFacade.new(
        igdb_id: id,
        pathname: @@model.name.pluralize.underscore,
        twitch_bearer_token: @@twitch_bearer_token,
      )
    facade.get_igdb_data
  end

  def populate_resource_fields(resource, igdb_data)
    @@fields_facade.new(resource, igdb_data).populate_fields
  end
end
