require "test_helper"

class Api::Games::PlayerPerspectiveGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @facade =
      Api::Games::PlayerPerspectiveGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should add player_perspectives to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_player_perspectives_to_game
    player_perspective_ids = @game.player_perspectives.map(&:igdb_id)
    igdb_game_data["player_perspectives"].each do |id|
      assert player_perspective_ids.include? id
    end
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_player_perspectives_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon player_perspective failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_player_perspective_failures: true,
    )
    @facade.add_player_perspectives_to_game
    ids = igdb_game_data["player_perspectives"]
    @game.errors[:player_perspectives].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
