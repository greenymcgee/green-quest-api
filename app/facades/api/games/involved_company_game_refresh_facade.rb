class Api::Games::InvolvedCompanyGameRefreshFacade < Api::Games::InvolvedCompanyGameCreateFacade
  def refresh_game_involved_companies
    set_involved_companies_response
    add_involved_companies_errors_to_game
    add_companies_errors_to_game
    add_company_logos_errors_to_game
    @involved_companies_response[:involved_companies].each do |involved_company|
      next if game.involved_companies.exists?(id: involved_company.id)

      game.involved_companies << involved_company
    end
  end

  private

  def set_involved_companies_response
    facade =
      Api::InvolvedCompanies::RefreshFacade.new(
        game: game,
        ids: igdb_game_data["involved_companies"],
        twitch_bearer_token: twitch_bearer_token,
      )
    @involved_companies_response = facade.find_or_create_involved_companies
  end
end
