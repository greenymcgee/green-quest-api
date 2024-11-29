require "test_helper"

class Api::Games::GameEngineGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @facade =
      Api::Games::GameEngineGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should add game_engines to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_engines_to_game
    game_engine_ids = @game.game_engines.map(&:igdb_id)
    igdb_game_data["game_engines"].each do |id|
      assert game_engine_ids.include? id
    end
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_engines_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon game_engine failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_game_engine_failures: true,
    )
    @facade.add_game_engines_to_game
    ids = igdb_game_data["game_engines"]
    @game.errors[:game_engines].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end

  test "should add errors to game upon game_engine_logo failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_game_engine_logo_failures: true,
    )
    @facade.add_game_engines_to_game
    assert_equal(
      stubbed_game_engine_logo_ids.count,
      @game.errors[:game_engine_logos].first.count,
    )
  end
end
