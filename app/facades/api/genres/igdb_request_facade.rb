class Api::Genres::IgdbRequestFacade
  def initialize(igdb_id, twitch_bearer_token)
    @@igdb_id = igdb_id
    @@bearer_token = twitch_bearer_token
  end

  def get_igdb_genre_data
    request_genre_data
    begin
      raise StandardError.new(@@resource[:error]) if @@resource[:error].present?

      set_igdb_genre_data
      { igdb_genre_data: @@igdb_genre_data }
    rescue StandardError => error
      { error: error }
    end
  end

  private

  def request_genre_data
    set_resource
    set_genre_response
  end

  def set_resource
    facade = IgdbApiFacade.new("genres/#{@@igdb_id}", @@bearer_token)
    @@resource = facade.get_igdb_api_resource
  end

  def set_genre_response
    @@genre_response = @@resource[:response]
  end

  def set_igdb_genre_data
    @@igdb_genre_data, = JSON.parse(@@genre_response.body)
  end
end
