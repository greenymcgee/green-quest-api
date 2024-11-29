class Api::GameEngines::CreateFacade
  include IgdbFieldsHelper

  def initialize(ids, twitch_bearer_token)
    @@twitch_bearer_token = twitch_bearer_token
    @@ids = ids || []
    @@errors = { game_engines: [], game_engine_logos: [] }
  end

  def find_or_create_game_engines
    { errors: @@errors, game_engines: game_engines }
  end

  private

  def game_engines
    @@ids.map do |id|
      GameEngine.find_or_initialize_by(igdb_id: id) do |game_engine|
        igdb_data_response = get_game_engine_igdb_data(id)
        next if add_game_engine_igdb_error(id, igdb_data_response[:error])

        igdb_data = igdb_data_response[:igdb_data]
        populate_game_engine_fields(game_engine, igdb_data)
        set_game_engine_game_engine_logo(game_engine, igdb_data)
        game_engine.errors.each { |error| @@errors[:game_engines] << error }
      end
    end
  end

  def add_game_engine_igdb_error(id, error)
    return false unless error.present?

    @@errors[:game_engines] << { id => JSON.parse(error.message) }
  end

  def get_game_engine_igdb_data(id)
    IgdbRequestFacade.new(
      igdb_id: id,
      pathname: "game_engines",
      twitch_bearer_token: @@twitch_bearer_token,
    ).get_igdb_data
  end

  def populate_game_engine_fields(game_engine, igdb_game_engine_data)
    Api::GameEngines::IgdbFieldsFacade.new(
      game_engine,
      igdb_game_engine_data,
    ).populate_fields
  end

  def create_game_engine_logo(id, game_engine)
    IgdbCreateFacade.new(
      fields_facade: Igdb::ImageFieldsFacade,
      ids: [id],
      model: GameEngineLogo,
      twitch_bearer_token: @@twitch_bearer_token,
    ).find_or_create_resources(game_engine_logo_callback(game_engine))
  end

  def game_engine_logo_callback(game_engine)
    ->(game_engine_logo) { game_engine.game_engine_logo = game_engine_logo }
  end

  def set_game_engine_game_engine_logo(game_engine, igdb_data)
    return false unless igdb_data["logo"].present?

    logo_response = create_game_engine_logo(igdb_data["logo"], game_engine)
    add_game_engine_logo_error(logo_response[:errors].first)
  end

  def add_game_engine_logo_error(error)
    return false unless error.present?

    @@errors[:game_engine_logos] << error
  end
end
