class Api::Games::ArtworkGameRefreshFacade < Api::Games::ArtworkGameCreateFacade
  def refresh_game_artworks
    set_artworks_response
    add_artworks_errors_to_game
  end

  private

  def set_artworks_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Igdb::ImageFieldsFacade,
        ids: igdb_game_data["artworks"],
        model: Artwork,
        twitch_bearer_token: twitch_bearer_token,
      )
    @artworks_response =
      facade.find_or_create_resources(
        ->(artwork) do
          return if game.artworks.exists?(id: artwork.id)

          artwork.game = game
        end,
      )
  end
end
