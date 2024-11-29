class Api::Companies::CreateFacade
  include IgdbFieldsHelper

  def initialize(id, twitch_bearer_token)
    @@twitch_bearer_token = twitch_bearer_token
    @@id = id
    @@errors = { companies: [], company_logos: [] }
  end

  def find_or_create_company
    { errors: @@errors, company: company }
  end

  private

  def company
    Company.find_or_initialize_by(igdb_id: @@id) do |company|
      next if company.id.present?

      igdb_response = get_company_igdb_data(@@id)
      next if add_company_igdb_error(@@id, igdb_response[:error])

      igdb_data = igdb_response[:igdb_data]
      populate_company_fields(company, igdb_data)
      set_company_company_logo(company, igdb_data)
      company.errors.each { |error| @@errors[:companies] << error }
    end
  end

  def add_company_igdb_error(id, error)
    return false unless error.present?

    @@errors[:companies] << { id => JSON.parse(error.message) }
  end

  def get_company_igdb_data(id)
    IgdbRequestFacade.new(
      igdb_id: id,
      pathname: "companies",
      twitch_bearer_token: @@twitch_bearer_token,
    ).get_igdb_data
  end

  def populate_company_fields(company, igdb_data)
    Api::Companies::IgdbFieldsFacade.new(company, igdb_data).populate_fields
  end

  def create_company_logo(id, company)
    IgdbCreateFacade.new(
      fields_facade: Igdb::ImageFieldsFacade,
      ids: [id],
      model: CompanyLogo,
      twitch_bearer_token: @@twitch_bearer_token,
    ).find_or_create_resources(company_logo_callback(company))
  end

  def company_logo_callback(company)
    ->(company_logo) { company.company_logo = company_logo }
  end

  def set_company_company_logo(company, igdb_data)
    return false unless igdb_data["logo"].present?

    logo_response = create_company_logo(igdb_data["logo"], company)
    add_company_logo_error(logo_response[:errors].first)
  end

  def add_company_logo_error(error)
    return false unless error.present?

    @@errors[:company_logos] << error
  end
end
