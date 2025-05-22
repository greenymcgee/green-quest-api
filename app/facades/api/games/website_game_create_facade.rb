class Api::Games::WebsiteGameCreateFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
  end

  def add_websites_to_game
    set_websites_response
    add_websites_errors_to_game
  end

  private

  def set_websites_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::Websites::IgdbFieldsFacade,
        ids: igdb_game_data["websites"],
        model: Website,
        twitch_bearer_token: twitch_bearer_token,
      )
    @websites_response =
      facade.find_or_create_resources(->(website) { website.game = game })
  end

  def add_websites_errors_to_game
    return false unless @websites_response[:errors].present?

    game.errors.add(:websites, @websites_response[:errors])
  end
end
