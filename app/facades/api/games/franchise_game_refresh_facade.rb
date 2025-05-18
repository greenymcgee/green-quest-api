class Api::Games::FranchiseGameRefreshFacade < Api::Games::FranchiseGameCreateFacade
  def refresh_game_franchises
    set_franchises_response
    add_franchises_errors_to_game
    @franchises_response[:resources].each do |franchise|
      return if game.franchises.exists?(id: franchise.id)

      franchise.main = game.main_franchise_id === franchise.igdb_id
      game.franchises << franchise
    end
  end

  private

  def set_franchises_response
    @franchises_response =
      IgdbRefreshFacade.new(
        fields_facade: Api::Franchises::IgdbFieldsFacade,
        ids: igdb_game_data["franchises"],
        model: Franchise,
        twitch_bearer_token: twitch_bearer_token,
      ).find_or_create_resources
  end
end
