class Api::Games::GenreGameRefreshFacade < Api::Games::GenreGameCreateFacade
  def refresh_game_genres
    set_genres_response
    add_genres_errors_to_game
    @genres_response[:resources].each do |genre|
      return if game.genres.exists?(id: genre.id)

      game.genres << genre
    end
  end

  private

  def set_genres_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Api::Genres::IgdbFieldsFacade,
        ids: igdb_game_data["genres"],
        model: Genre,
        twitch_bearer_token: twitch_bearer_token,
      )
    @genres_response = facade.find_or_create_resources
  end
end
