class Api::Games::GameModeGameCreateFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
  end

  def add_game_modes_to_game
    set_game_modes_response
    add_game_modes_errors_to_game
    @game_modes_response[:resources].each do |game_mode|
      game.game_modes << game_mode
    end
  end

  private

  def set_game_modes_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::GameModes::IgdbFieldsFacade,
        ids: igdb_game_data["game_modes"],
        model: GameMode,
        twitch_bearer_token: twitch_bearer_token,
      )
    @game_modes_response = facade.find_or_create_resources
  end

  def add_game_modes_errors_to_game
    return false unless @game_modes_response[:errors].present?

    game.errors.add(:game_modes, @game_modes_response[:errors])
  end
end
