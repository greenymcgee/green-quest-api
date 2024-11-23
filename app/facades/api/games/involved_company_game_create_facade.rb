class Api::Games::InvolvedCompanyGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_involved_companies_to_game
    set_involved_companies_response
    add_involved_companies_errors_to_game
    add_companies_errors_to_game
    @@involved_companies_response[
      :involved_companies
    ].each { |involved_company| @@game.involved_companies << involved_company }
  end

  private

  def set_involved_companies_response
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @@game,
        ids: @@igdb_game_data["involved_companies"],
        twitch_bearer_token: @@twitch_bearer_token,
      )
    @@involved_companies_response = facade.find_or_create_involved_companies
  end

  def add_involved_companies_errors_to_game
    unless @@involved_companies_response[:errors][:involved_companies].present?
      return
    end

    @@game.errors.add(
      :involved_companies,
      @@involved_companies_response[:errors][:involved_companies],
    )
  end

  def add_companies_errors_to_game
    return unless @@involved_companies_response[:errors][:companies].present?

    @@game.errors.add(
      :companies,
      @@involved_companies_response[:errors][:companies],
    )
  end
end
