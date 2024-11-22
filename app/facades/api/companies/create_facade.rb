class Api::Companies::CreateFacade
  include IgdbFieldsHelper

  def initialize(ids, twitch_bearer_token)
    @@twitch_bearer_token = twitch_bearer_token
    @@ids = ids || []
    @@errors = []
  end

  def find_or_create_companies
    { errors: @@errors, companies: companies }
  end

  private

  def companies
    @@ids.map do |id|
      Company.find_or_initialize_by(igdb_id: id) do |company|
        next if company.id.present?

        company_request = set_company_facade(id).get_igdb_company_data
        if company_request[:error].present?
          add_company_error(id, company_request[:error])
          next
        end

        set_company_properties(company, company_request[:igdb_company_data])
        company.save
        company.errors.each { |error| @@errors << error }
      end
    end
  end

  def add_company_error(id, error)
    @@errors << { id => JSON.parse(error.message) }
  end

  def set_company_facade(id)
    Api::Companies::IgdbRequestFacade.new(id, @@twitch_bearer_token)
  end

  def set_company_properties(company, igdb_company_data)
    facade = Api::Companies::IgdbFieldsFacade.new(company, igdb_company_data)
    facade.populate_company_fields
  end
end
