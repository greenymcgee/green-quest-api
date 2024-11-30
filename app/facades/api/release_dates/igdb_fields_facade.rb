class Api::ReleaseDates::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(release_date, igdb_data)
    @@release_date = release_date
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@release_date.update(
      category_enum: category_enum,
      checksum: checksum,
      date: date,
      human_readable: human_readable,
      month: month,
      platform: platform,
      region_enum: region_enum,
      year: year,
    )
  end

  private

  def category_enum
    get_present_value(@@release_date.category_enum, @@igdb_data["category"])
  end

  def checksum
    get_present_value(@@release_date.checksum, @@igdb_data["checksum"])
  end

  def date_unix_timestamp
    @@igdb_data["date"]
  end

  def date_to_datetime
    return unless date_unix_timestamp.present?

    Time.at(date_unix_timestamp).utc.to_datetime
  end

  def date
    get_present_value(@@release_date.date, date_to_datetime)
  end

  def human_readable
    get_present_value(@@release_date.human_readable, @@igdb_data["human"])
  end

  def month
    get_present_value(@@release_date.month, @@igdb_data["m"])
  end

  def platform
    Platform.find_by(igdb_id: @@igdb_data["platform"])
  end

  def region_enum
    @@igdb_data["region"]
  end

  def year
    get_present_value(@@release_date.year, @@igdb_data["y"])
  end
end
