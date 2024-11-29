class Api::Games::FranchiseGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_franchises_to_game
    set_franchises_response
    add_franchises_errors_to_game
    @@franchises_response[:resources].each do |franchise|
      @@game.franchises << franchise
    end
  end

  private

  def set_franchises_response
    @@franchises_response =
      IgdbCreateFacade.new(
        fields_facade: Api::Franchises::IgdbFieldsFacade,
        ids: @@igdb_game_data["franchises"],
        model: Franchise,
        twitch_bearer_token: @@twitch_bearer_token,
      ).find_or_create_resources
  end

  def add_franchises_errors_to_game
    return false unless @@franchises_response[:errors].present?

    @@game.errors.add(:franchises, @@franchises_response[:errors])
  end
end
