class Api::Platforms::IgdbRequestFacade
  def initialize(igdb_id, twitch_bearer_token)
    @@igdb_id = igdb_id
    @@bearer_token = twitch_bearer_token
  end

  def get_igdb_platform_data
    request_platform_data
    begin
      raise StandardError.new(@@resource[:error]) if @@resource[:error].present?

      set_igdb_platform_data
      { igdb_platform_data: @@igdb_platform_data }
    rescue StandardError => error
      { error: error }
    end
  end

  private

  def request_platform_data
    set_resource
    set_response
  end

  def set_resource
    facade = IgdbApiFacade.new("platforms/#{@@igdb_id}", @@bearer_token)
    @@resource = facade.get_igdb_api_resource
  end

  def set_response
    @@response = @@resource[:response]
  end

  def set_igdb_platform_data
    @@igdb_platform_data, = JSON.parse(@@response.body)
  end
end
