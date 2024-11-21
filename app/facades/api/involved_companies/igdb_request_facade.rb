class Api::InvolvedCompanies::IgdbRequestFacade
  def initialize(igdb_id, twitch_bearer_token)
    @@igdb_id = igdb_id
    @@bearer_token = twitch_bearer_token
  end

  def get_igdb_involved_company_data
    request_involved_company_data
    begin
      raise StandardError.new(@@resource[:error]) if @@resource[:error].present?

      set_igdb_involved_company_data
      { igdb_involved_company_data: @@igdb_involved_company_data }
    rescue StandardError => error
      { error: error }
    end
  end

  private

  def request_involved_company_data
    set_resource
    set_response
  end

  def set_resource
    facade =
      IgdbApiFacade.new("involved_companies/#{@@igdb_id}", @@bearer_token)
    @@resource = facade.get_igdb_api_resource
  end

  def set_response
    @@response = @@resource[:response]
  end

  def set_igdb_involved_company_data
    @@igdb_involved_company_data, = JSON.parse(@@response.body)
  end
end
