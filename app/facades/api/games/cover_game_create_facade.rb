class Api::Games::CoverGameCreateFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
  end

  def add_cover_to_game
    set_cover_response
    add_cover_errors_to_game
  end

  private

  def set_cover_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Igdb::ImageFieldsFacade,
        ids: [igdb_game_data["cover"]],
        model: Cover,
        twitch_bearer_token: twitch_bearer_token,
      )
    @cover_response =
      facade.find_or_create_resources(->(resource) { resource.game = game })
  end

  def add_cover_errors_to_game
    return false unless @cover_response[:errors].present?

    game.errors.add(:cover, @cover_response[:errors])
  end
end
