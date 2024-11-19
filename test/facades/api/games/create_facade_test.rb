require "test_helper"

class Api::Games::CreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::CreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should add genres to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert_equal(@game.genres.map(&:igdb_id), @igdb_game_data["genres"])
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert @game.errors.blank?
  end

  test "should add errors to game upon genre failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_genre_failures: true,
    )
    @facade.add_game_resources
    assert_equal(
      @game.errors.messages,
      { genres: [[{ 31 => { "message" => "Not authorized" } }]] },
    )
  end
end
