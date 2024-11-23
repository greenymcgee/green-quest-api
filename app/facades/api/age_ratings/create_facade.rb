class Api::AgeRatings::CreateFacade
  def initialize(ids, twitch_bearer_token)
    @@twitch_bearer_token = twitch_bearer_token
    @@ids = ids || []
    @@errors = []
  end

  def find_or_create_age_ratings
    { errors: @@errors, age_ratings: age_ratings }
  end

  private

  def age_ratings
    @@ids.map do |id|
      AgeRating.find_or_initialize_by(igdb_id: id) do |age_rating|
        next if age_rating.id.present?

        igdb_request = get_igdb_data(id)
        next if add_age_rating_error(id, igdb_request[:error])

        populate_age_rating_fields(age_rating, igdb_request[:igdb_data])
        age_rating.save
        age_rating.errors.each { |error| @@errors << error }
      end
    end
  end

  def add_age_rating_error(id, error)
    return false unless error.present?

    @@errors << { id => JSON.parse(error.message) }
  end

  def get_igdb_data(id)
    facade = Api::AgeRatings::IgdbRequestFacade.new(id, @@twitch_bearer_token)
    facade.get_igdb_data
  end

  def populate_age_rating_fields(age_rating, igdb_data)
    facade = Api::AgeRatings::IgdbFieldsFacade.new(age_rating, igdb_data)
    facade.populate_age_rating_fields
  end
end
