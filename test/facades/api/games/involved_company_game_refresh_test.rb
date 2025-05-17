require "test_helper"

class Api::Games::InvolvedCompanyGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @create_facade =
      Api::Games::InvolvedCompanyGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::InvolvedCompanyGameRefreshFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should refresh game involved company data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_involved_companies_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_involved_companies
    igdb_game_data["involved_companies"].each do |id|
      involved_company_json =
        JSON.parse(json_mocks("igdb/involved_companies/#{id}.refresh.json"))
      game_involved_company = @game.involved_companies.find_by(igdb_id: id)
      company_json =
        JSON.parse(
          json_mocks(
            "igdb/companies/#{game_involved_company.company.igdb_id}.refresh.json",
          ),
        )
      assert_equal(
        involved_company_json.first["checksum"],
        game_involved_company.checksum,
      )
      assert_equal(
        company_json.first["slug"],
        game_involved_company.company.slug,
      )
      if game_involved_company.company.company_logo.present?
        company_logo_json =
          JSON.parse(
            json_mocks(
              "igdb/company_logos/#{game_involved_company.company.company_logo&.igdb_id}.refresh.json",
            ),
          )
        assert company_logo_json.first["url"].include? "refresh"
      end
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_involved_companies_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_involved_companies
    assert_equal(
      igdb_game_data["involved_companies"].count,
      @game.involved_companies.count,
    )
    assert_equal(
      @game.involved_companies.distinct.count,
      @game.involved_companies.count,
    )
  end
end
