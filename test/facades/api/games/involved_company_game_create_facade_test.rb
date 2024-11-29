require "test_helper"

class Api::Games::InvolvedCompanyGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::InvolvedCompanyGameCreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should add involved companies to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_involved_companies_to_game
    involved_company_ids = @game.involved_companies.map(&:igdb_id)
    @igdb_game_data["involved_companies"].each do |id|
      assert involved_company_ids.include? id
    end
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_involved_companies_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon involved company failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_involved_company_failures: true,
    )
    @facade.add_involved_companies_to_game
    ids = @igdb_game_data["involved_companies"]
    @game.errors[:involved_companies].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end

  test "should add errors to game upon company failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_company_failures: true,
    )
    @facade.add_involved_companies_to_game
    assert_equal(
      @game.errors[:companies].first.count,
      stubbed_company_ids.count,
    )
  end

  test "should add errors to game upon company logo failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_company_logo_failures: true,
    )
    @facade.add_involved_companies_to_game
    assert_equal(
      @game.errors[:company_logos].first.count,
      stubbed_company_logo_ids.count,
    )
  end
end
