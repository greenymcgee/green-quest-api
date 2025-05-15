class IgdbCreateFacade
  attr_reader :errors
  attr_reader :fields_facade
  attr_reader :ids
  attr_reader :model
  attr_reader :twitch_bearer_token

  def initialize(fields_facade:, ids:, model:, twitch_bearer_token:)
    @errors = []
    @fields_facade = fields_facade
    @ids = ids || []
    @model = model
    @twitch_bearer_token = twitch_bearer_token
  end

  # Takes a callback that receives an individual resource for establishing the
  # relationship between the game and the resource.
  def find_or_create_resources(callback = nil)
    { errors: errors, resources: resources(callback) }
  end

  private

  def resources(callback)
    ids.map do |id|
      RequestThrottlerRegistry.instance.throttle do
        record = find_or_initialize_record(id)
        save_record(record, callback)
        record
      end
    end
  end

  def save_record(record, callback)
    # If this hits, that means the IGDB request didn't go as expected
    return if errors.present?

    callback.call(record) if callback.present?
    record.save
    record.errors.each { |error| errors << error }
  end

  def find_or_initialize_record(id)
    model.find_or_initialize_by(igdb_id: id) do |resource|
      igdb_response = get_igdb_data(id)
      next if encountered_errors?(id, igdb_response)

      populate_resource_fields(resource, igdb_response[:igdb_data])
    end
  end

  def encountered_errors?(id, igdb_response)
    add_igdb_error(id, igdb_response[:error]) ||
      add_blank_data_error(id, igdb_response[:igdb_data])
  end

  def add_blank_data_error(id, igdb_data)
    return false unless igdb_data.blank?

    errors << { id => "IGDB data is blank" }
  end

  def add_igdb_error(id, error)
    return false unless error.present?

    errors << { id => JSON.parse(error.message) }
  end

  def get_igdb_data(id)
    facade =
      IgdbRequestFacade.new(
        igdb_id: id,
        pathname: model.name.pluralize.underscore,
        twitch_bearer_token: twitch_bearer_token,
      )
    facade.get_igdb_data
  end

  def populate_resource_fields(resource, igdb_data)
    fields_facade.new(resource, igdb_data).populate_fields
  end
end
