class Api::InvolvedCompanies::CreateFacade
  include IgdbFieldsHelper

  def initialize(game:, ids:, twitch_bearer_token:)
    @@twitch_bearer_token = twitch_bearer_token
    @@game = game
    @@ids = ids || []
    @@errors = { companies: [], company_logos: [], involved_companies: [] }
  end

  def find_or_create_involved_companies
    { errors: @@errors, involved_companies: involved_companies }
  end

  private

  def involved_companies
    @@ids.map do |id|
      InvolvedCompany.find_or_initialize_by(igdb_id: id) do |involved_company|
        igdb_response = get_igdb_data(id)
        igdb_data = igdb_response[:igdb_data]
        igdb_error = igdb_response[:error]
        next if unprocessable_igdb_response?(id, igdb_data, igdb_error)

        next unless set_involved_company_company(involved_company, igdb_data)

        involved_company.game = @@game
        populate_involved_company_fields(involved_company, igdb_data)
        set_involved_company_errors(involved_company)
      end
    end
  end

  def unprocessable_igdb_response?(id, data, error)
    add_involved_company_error(id, error) || data.blank?
  end

  def set_involved_company_errors(involved_company)
    involved_company.errors.each do |error|
      @@errors[:involved_companies] << error
    end
  end

  def find_or_create_company(id)
    Api::Companies::CreateFacade.new(
      id,
      @@twitch_bearer_token,
    ).find_or_create_company
  end

  def set_involved_company_company(involved_company, igdb_data)
    company_response = find_or_create_company(igdb_data["company"])
    errors = company_response[:errors]
    return false if add_company_error(errors[:companies].first)

    add_company_logo_error(errors[:company_logos].first)
    involved_company.company = company_response[:company]
  end

  def add_company_error(error)
    return false unless error.present?

    @@errors[:companies] << error
  end

  def add_company_logo_error(error)
    return false unless error.present?

    @@errors[:company_logos] << error
  end

  def add_involved_company_error(id, error)
    return false unless error.present?

    @@errors[:involved_companies] << { id => JSON.parse(error.message) }
  end

  def get_igdb_data(id)
    facade =
      IgdbRequestFacade.new(
        igdb_id: id,
        pathname: "involved_companies",
        twitch_bearer_token: @@twitch_bearer_token,
      )
    facade.get_igdb_data
  end

  def populate_involved_company_fields(involved_company, data)
    facade =
      Api::InvolvedCompanies::IgdbFieldsFacade.new(involved_company, data)
    facade.populate_involved_company_fields
  end
end
