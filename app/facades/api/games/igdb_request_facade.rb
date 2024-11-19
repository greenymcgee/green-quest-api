class Api::Games::IgdbRequestFacade
  def initialize(igdb_id)
    @@igdb_id = igdb_id
  end

  def get_igdb_game_data
    request_bearer_token
    begin
      if @@twitch_oauth_response[:error].present?
        raise StandardError.new(@@twitch_oauth_response[:error])
      end

      request_game_data
      raise StandardError.new(@@resource[:error]) if @@resource[:error].present?

      set_igdb_game_data
      { igdb_game_data: @@igdb_game_data, twitch_bearer_token: @@bearer_token }
    rescue StandardError => error
      { error: error }
    end
  end

  private

  def request_bearer_token
    set_twitch_oauth_response
    set_bearer_token
  end

  def request_game_data
    set_resource
    set_game_response
  end

  def set_twitch_oauth_response
    @@twitch_oauth_response = TwitchOauthFacade.get_twitch_oauth_token
  end

  def set_bearer_token
    @@bearer_token = @@twitch_oauth_response[:bearer_token]
  end

  def set_resource
    facade = IgdbApiFacade.new("games/#{@@igdb_id}", @@bearer_token)
    @@resource = facade.get_igdb_api_resource
  end

  def set_game_response
    @@game_response = @@resource[:response]
  end

  def set_igdb_game_data
    @@igdb_game_data, = JSON.parse(@@game_response.body)
  end
end
