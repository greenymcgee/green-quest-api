class Api::Games::AgeRatingGameRefreshFacade < Api::Games::AgeRatingGameCreateFacade
  def refresh_game_age_ratings
    set_age_ratings_response
    add_age_ratings_errors_to_game
    @age_ratings_response[:resources].each do |age_rating|
      next if game.age_ratings.exists?(id: age_rating.id)

      game.age_ratings << age_rating
    end
  end

  private

  def set_age_ratings_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Api::AgeRatings::IgdbFieldsFacade,
        ids: igdb_game_data["age_ratings"],
        model: AgeRating,
        twitch_bearer_token: twitch_bearer_token,
      )
    @age_ratings_response = facade.find_or_create_resources
  end
end
