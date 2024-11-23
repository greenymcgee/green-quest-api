class Api::AgeRatings::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(age_rating, igdb_data)
    @@age_rating = age_rating
    @@igdb_data = igdb_data
  end

  def populate_age_rating_fields
    @@age_rating.update(
      category_enum: category_enum,
      checksum: checksum,
      rating_enum: rating_enum,
      rating_cover_url: rating_cover_url,
      synopsis: synopsis,
    )
  end

  private

  def category_enum
    get_present_value(@@age_rating.category_enum, @@igdb_data["category"])
  end

  def checksum
    get_present_value(@@age_rating.checksum, @@igdb_data["checksum"])
  end

  def rating_enum
    get_present_value(@@age_rating.rating_enum, @@igdb_data["rating"])
  end

  def rating_cover_url
    get_present_value(
      @@age_rating.rating_cover_url,
      @@igdb_data["rating_cover_url"],
    )
  end

  def synopsis
    get_present_value(@@age_rating.synopsis, @@igdb_data["synopsis"])
  end
end
