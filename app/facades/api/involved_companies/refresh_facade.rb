class Api::InvolvedCompanies::RefreshFacade < Api::InvolvedCompanies::CreateFacade
  def involved_companies
    ids.map do |id|
      involved_company = InvolvedCompany.find_or_initialize_by(igdb_id: id)
      igdb_response = get_igdb_data(id)
      igdb_data = igdb_response[:igdb_data]
      igdb_error = igdb_response[:error]
      if unprocessable_igdb_response?(id, igdb_data, igdb_error)
        next involved_company
      end

      unless set_involved_company_company(involved_company, igdb_data)
        next involved_company
      end

      involved_company.game = game
      populate_involved_company_fields(involved_company, igdb_data)
      set_involved_company_errors(involved_company)
      involved_company
    end
  end

  def find_or_create_company(id)
    Api::Companies::RefreshFacade.new(
      id,
      twitch_bearer_token,
    ).find_or_create_company
  end
end
