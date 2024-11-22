class Api::Companies::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(company, igdb_data)
    @@company = company
    @@igdb_data = igdb_data
  end

  def populate_company_fields
    @@company.update(
      change_date: change_date,
      change_date_category_enum: change_date_category_enum,
      changed_company_id: changed_company_id,
      checksum: checksum,
      country_code: country_code,
      developed_game_ids: developed_game_ids,
      description: description,
      igdb_url: igdb_url,
      name: name,
      parent_id: parent_id,
      published_game_ids: published_game_ids,
      slug: slug,
      start_date: start_date,
    )
  end

  private

  def change_date_unix_timestamp
    @@igdb_data["change_date"]
  end

  def change_date_to_datetime
    return unless change_date_unix_timestamp.present?

    Time.at(change_date_unix_timestamp).utc.to_datetime
  end

  def change_date
    get_present_value(@@company.change_date, change_date_to_datetime)
  end

  def change_date_category_enum
    get_present_value(
      @@company.change_date_category_enum,
      @@igdb_data["change_date_category"],
    )
  end

  def changed_company_id
    get_present_value(
      @@company.changed_company_id,
      @@igdb_data["changed_company_id"],
    )
  end

  def checksum
    get_present_value(@@company.checksum, @@igdb_data["checksum"])
  end

  def country_code
    get_present_value(@@company.country_code, @@igdb_data["country"])
  end

  def description
    get_present_value(@@company.description, @@igdb_data["description"])
  end

  def developed_game_ids
    get_present_value(@@company.developed_game_ids, @@igdb_data["developed"])
  end

  def igdb_url
    get_present_value(@@company.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@company.name, @@igdb_data["name"])
  end

  def parent_id
    get_present_value(@@company.parent_id, @@igdb_data["parent"])
  end

  def published_game_ids
    get_present_value(@@company.published_game_ids, @@igdb_data["published"])
  end

  def slug
    get_present_value(@@company.slug, @@igdb_data["slug"])
  end

  def start_date_unix_timestamp
    @@igdb_data["start_date"]
  end

  def start_date_to_datetime
    return unless start_date_unix_timestamp.present?

    Time.at(start_date_unix_timestamp).utc.to_datetime
  end

  def start_date
    get_present_value(@@company.start_date, start_date_to_datetime)
  end
end
