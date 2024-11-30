class Api::Games::ThemeGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_themes_to_game
    set_themes_response
    add_themes_errors_to_game
    @@themes_response[:resources].each { |theme| @@game.themes << theme }
  end

  private

  def set_themes_response
    @@themes_response =
      IgdbCreateFacade.new(
        fields_facade: Api::Themes::IgdbFieldsFacade,
        ids: @@igdb_game_data["themes"],
        model: Theme,
        twitch_bearer_token: @@twitch_bearer_token,
      ).find_or_create_resources
  end

  def add_themes_errors_to_game
    return false unless @@themes_response[:errors].present?

    @@game.errors.add(:themes, @@themes_response[:errors])
  end
end
