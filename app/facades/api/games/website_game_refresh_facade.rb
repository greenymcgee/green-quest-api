class Api::Games::WebsiteGameRefreshFacade < Api::Games::WebsiteGameCreateFacade
  def refresh_game_websites
    set_websites_response
    add_websites_errors_to_game
  end

  private

  def set_websites_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Api::Websites::IgdbFieldsFacade,
        ids: igdb_game_data["websites"],
        model: Website,
        twitch_bearer_token: twitch_bearer_token,
      )
    @websites_response =
      facade.find_or_create_resources(
        ->(website) do
          return if website.game.present?

          website.game = game
        end,
      )
  end
end
