require "test_helper"

class Api::Games::CoverGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::CoverGameCreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should add cover to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_cover_to_game
    assert_equal @game.cover.igdb_id, @igdb_game_data["cover"]
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_cover_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon cover failure" do
    stub_successful_game_create_request(@game.igdb_id, with_cover_failure: true)
    @facade.add_cover_to_game
    @game.errors[:cover].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [@igdb_game_data["cover"], { "message" => "Not authorized" }],
      )
    end
  end
end
