class Api::InvolvedCompanies::CreateFacade
  include IgdbFieldsHelper

  def initialize(game:, ids:, twitch_bearer_token:)
    @@twitch_bearer_token = twitch_bearer_token
    @@game = game
    @@ids = ids || []
    @@errors = { companies: [], involved_companies: [] }
  end

  def find_or_create_involved_companies
    { errors: @@errors, involved_companies: involved_companies }
  end

  private

  def involved_companies
    @@ids.map do |id|
      InvolvedCompany.find_or_initialize_by(igdb_id: id) do |involved_company|
        next if involved_company.id.present?

        igdb_data_request = get_igdb_data(id)
        next if add_involved_company_error(id, igdb_data_request[:error])

        igdb_data = igdb_data_request[:igdb_involved_company_data]
        next unless set_involved_company_company(involved_company, igdb_data)

        involved_company.game = @@game
        populate_involved_company_fields(involved_company, igdb_data)
        set_involved_company_errors(involved_company)
      end
    end
  end

  def set_involved_company_errors(involved_company)
    involved_company.errors.each do |error|
      @@errors[:involved_companies] << error
    end
  end

  def find_or_create_company(id)
    facade = Api::Companies::CreateFacade.new(id, @@twitch_bearer_token)
    facade.find_or_create_company
  end

  def set_involved_company_company(involved_company, igdb_data)
    company_response = find_or_create_company(igdb_data["company"])
    return false if add_company_error(company_response[:errors].first)

    involved_company.company = company_response[:company]
  end

  def add_company_error(error)
    return false unless error.present?

    @@errors[:companies] << error
  end

  def add_involved_company_error(id, error)
    return false unless error.present?

    @@errors[:involved_companies] << { id => JSON.parse(error.message) }
  end

  def get_igdb_data(id)
    facade =
      Api::InvolvedCompanies::IgdbRequestFacade.new(id, @@twitch_bearer_token)
    facade.get_igdb_involved_company_data
  end

  def populate_involved_company_fields(involved_company, data)
    facade =
      Api::InvolvedCompanies::IgdbFieldsFacade.new(involved_company, data)
    facade.populate_involved_company_fields
  end
end
