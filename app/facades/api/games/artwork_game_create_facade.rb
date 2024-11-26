class Api::Games::ArtworkGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_artworks_to_game
    set_artworks_response
    add_artworks_errors_to_game
  end

  private

  def set_artworks_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::Artworks::IgdbFieldsFacade,
        ids: @@igdb_game_data["artworks"],
        model: Artwork,
        twitch_bearer_token: @@twitch_bearer_token,
      )
    @@artworks_response =
      facade.find_or_create_resources(->(artwork) { artwork.game = @@game })
  end

  def add_artworks_errors_to_game
    return false unless @@artworks_response[:errors].present?

    @@game.errors.add(:artworks, @@artworks_response[:errors])
  end
end
