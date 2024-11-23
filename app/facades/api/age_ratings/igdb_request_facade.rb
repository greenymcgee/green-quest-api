class Api::AgeRatings::IgdbRequestFacade
  def initialize(igdb_id, twitch_bearer_token)
    @@igdb_id = igdb_id
    @@bearer_token = twitch_bearer_token
  end

  def get_igdb_data
    request_igdb_data
    begin
      raise StandardError.new(@@resource[:error]) if @@resource[:error].present?

      set_igdb_data
      { igdb_age_rating_data: @@igdb_age_rating_data }
    rescue StandardError => error
      { error: error }
    end
  end

  private

  def request_igdb_data
    set_resource
    set_igdb_response
  end

  def set_resource
    facade = IgdbApiFacade.new("age_ratings/#{@@igdb_id}", @@bearer_token)
    @@resource = facade.get_igdb_api_resource
  end

  def set_igdb_response
    @@igdb_response = @@resource[:response]
  end

  def set_igdb_data
    @@igdb_age_rating_data, = JSON.parse(@@igdb_response.body)
  end
end
