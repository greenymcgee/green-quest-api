class Api::Games::ReleaseDateGameRefreshFacade < Api::Games::ReleaseDateGameCreateFacade
  def refresh_game_release_dates
    set_release_dates_response
    add_release_dates_errors_to_game
  end

  private

  def set_release_dates_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Api::ReleaseDates::IgdbFieldsFacade,
        ids: igdb_game_data["release_dates"],
        model: ReleaseDate,
        twitch_bearer_token: twitch_bearer_token,
      )
    @release_dates_response =
      facade.find_or_create_resources(update_release_date_game)
  end

  def update_release_date_game
    ->(release_date) do
      return if release_date.game.present?

      release_date.game = game
    end
  end
end
