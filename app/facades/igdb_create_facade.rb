class IgdbCreateFacade
  def initialize(fields_facade:, ids:, model:, twitch_bearer_token:)
    @@errors = []
    @@fields_facade = fields_facade
    @@ids = ids
    @@model = model
    @@twitch_bearer_token = twitch_bearer_token
  end

  def find_or_create_resources
    { errors: @@errors, resources: resources }
  end

  private

  def resources
    @@ids.map do |id|
      @@model.find_or_initialize_by(igdb_id: id) do |resource|
        next if resource.id.present?

        igdb_request = get_igdb_data(id)
        next if add_resource_error(id, igdb_request[:error])

        populate_resource_fields(resource, igdb_request[:igdb_data])
        resource.errors.each { |error| @@errors << error }
      end
    end
  end

  def add_resource_error(id, error)
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
    facade = @@fields_facade.new(resource, igdb_data)
    facade.populate_fields
  end
end
