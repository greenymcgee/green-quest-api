class Api::Games::PlayerPerspectiveGameCreateFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
  end

  def add_player_perspectives_to_game
    set_player_perspectives_response
    add_player_perspectives_errors_to_game
    @player_perspectives_response[:resources].each do |player_perspective|
      game.player_perspectives << player_perspective
    end
  end

  private

  def set_player_perspectives_response
    @player_perspectives_response =
      IgdbCreateFacade.new(
        fields_facade: Api::PlayerPerspectives::IgdbFieldsFacade,
        ids: igdb_game_data["player_perspectives"],
        model: PlayerPerspective,
        twitch_bearer_token: twitch_bearer_token,
      ).find_or_create_resources
  end

  def add_player_perspectives_errors_to_game
    return false unless @player_perspectives_response[:errors].present?

    game.errors.add(
      :player_perspectives,
      @player_perspectives_response[:errors],
    )
  end
end
