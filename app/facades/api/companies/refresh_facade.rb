class Api::Companies::RefreshFacade < Api::Companies::CreateFacade
  def find_or_initialize_company
    company = Company.find_or_initialize_by(igdb_id: id)
    igdb_response = get_company_igdb_data
    igdb_data = igdb_response[:igdb_data]
    return company if encountered_errors?(igdb_response)

    populate_company_fields(company, igdb_data)
    set_company_company_logo(company, igdb_data)
    company
  end

  def create_company_logo(id, company)
    IgdbRefreshFacade.new(
      fields_facade: Igdb::ImageFieldsFacade,
      ids: [id],
      model: CompanyLogo,
      twitch_bearer_token: twitch_bearer_token,
    ).find_or_create_resources(company_logo_callback(company))
  end
end
