require "test_helper"

class Api::Games::GameModeGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::GameModeGameCreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should add game_modes to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_modes_to_game
    ids = @game.game_modes.map(&:igdb_id)
    @igdb_game_data["game_modes"].each { |id| assert ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_modes_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon game_modes failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_game_mode_failures: true,
    )
    @facade.add_game_modes_to_game
    ids = @igdb_game_data["game_modes"]
    @game.errors[:game_modes].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
