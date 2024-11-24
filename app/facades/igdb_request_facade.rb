class IgdbRequestFacade
  def initialize(igdb_id:, pathname:, twitch_bearer_token:)
    @@igdb_id = igdb_id
    @@bearer_token = twitch_bearer_token
    @@pathname = pathname
  end

  def get_igdb_data
    request_igdb_data
    begin
      raise StandardError.new(@@resource[:error]) if @@resource[:error].present?

      set_igdb_data
      { igdb_data: @@igdb_data }
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
    facade = IgdbApiFacade.new("#{@@pathname}/#{@@igdb_id}", @@bearer_token)
    @@resource = facade.get_igdb_api_resource
  end

  def set_igdb_response
    @@igdb_response = @@resource[:response]
  end

  def set_igdb_data
    @@igdb_data, = JSON.parse(@@igdb_response.body)
  end
end
