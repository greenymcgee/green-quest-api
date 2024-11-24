class Api::Games::AgeRatingGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_age_ratings_to_game
    set_age_ratings_response
    add_age_ratings_errors_to_game
    @@age_ratings_response[:age_ratings].each do |age_rating|
      @@game.age_ratings << age_rating
    end
  end

  private

  def set_age_ratings_response
    facade =
      Api::AgeRatings::CreateFacade.new(
        @@igdb_game_data["age_ratings"],
        @@twitch_bearer_token,
      )
    @@age_ratings_response = facade.find_or_create_age_ratings
  end

  def add_age_ratings_errors_to_game
    return false unless @@age_ratings_response[:errors].present?

    @@game.errors.add(:age_ratings, @@age_ratings_response[:errors])
  end
end
