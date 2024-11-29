require "test_helper"

class Api::Games::FranchiseGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::FranchiseGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should add franchises to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_franchises_to_game
    ids = @game.franchises.map(&:igdb_id)
    igdb_game_data["franchises"].each { |id| assert ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_franchises_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon franchise failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_franchise_failures: true,
    )
    @facade.add_franchises_to_game
    ids = igdb_game_data["franchises"]
    @game.errors[:franchises].first.each_with_index do |errors, index|
      assert_equal(
        [ids[index], { "message" => "Not authorized" }],
        errors.first,
      )
    end
  end
end
