class Api::GameEngines::RefreshFacade < Api::GameEngines::CreateFacade
  def game_engines
    ids.map do |id|
      RequestThrottlerRegistry.instance.throttle do
        game_engine = GameEngine.find_or_initialize_by(igdb_id: id)
        igdb_response = get_game_engine_igdb_data(id)
        igdb_data = igdb_response[:igdb_data]
        igdb_error = igdb_response[:error]
        if unprocessable_igdb_response?(id, igdb_data, igdb_error)
          next game_engine
        end

        populate_game_engine_fields(game_engine, igdb_data)
        game_engine.save
        set_game_engine_game_engine_logo(game_engine, igdb_data)
        game_engine.errors.each { |error| @errors[:game_engines] << error }
        game_engine
      end
    end
  end

  def create_game_engine_logo(id, game_engine)
    IgdbRefreshFacade.new(
      fields_facade: Igdb::ImageFieldsFacade,
      ids: [id],
      model: GameEngineLogo,
      twitch_bearer_token: twitch_bearer_token,
    ).find_or_create_resources(game_engine_logo_callback(game_engine))
  end
end
