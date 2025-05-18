class Api::Games::CoverGameRefreshFacade < Api::Games::CoverGameCreateFacade
  def refresh_game_cover
    set_cover_response
    add_cover_errors_to_game
  end

  private

  def set_cover_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Igdb::ImageFieldsFacade,
        ids: [igdb_game_data["cover"]],
        model: Cover,
        twitch_bearer_token: twitch_bearer_token,
      )
    @cover_response =
      facade.find_or_create_resources(
        ->(cover) do
          return if cover.game.present?

          cover.game = game
        end,
      )
  end
end
