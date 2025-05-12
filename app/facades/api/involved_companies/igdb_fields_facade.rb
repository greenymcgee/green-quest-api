class Api::InvolvedCompanies::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(involved_company, igdb_data)
    @@involved_company = involved_company
    @@igdb_data = igdb_data
  end

  def populate_involved_company_fields
    @@involved_company.update(
      checksum: checksum,
      is_developer: is_developer,
      is_porter: is_porter,
      is_publisher: is_publisher,
      is_supporter: is_supporter,
    )
  end

  private

  def checksum
    get_present_value(@@involved_company.checksum, @@igdb_data["checksum"])
  end

  def is_developer
    get_present_boolean_value(
      @@involved_company.is_developer,
      @@igdb_data["developer"],
    )
  end

  def is_porter
    get_present_boolean_value(
      @@involved_company.is_porter,
      @@igdb_data["porting"],
    )
  end

  def is_publisher
    get_present_boolean_value(
      @@involved_company.is_publisher,
      @@igdb_data["publisher"],
    )
  end

  def is_supporter
    get_present_boolean_value(
      @@involved_company.is_supporter,
      @@igdb_data["supporting"],
    )
  end
end
