require "test_helper"

class Api::Games::PlatformGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @facade =
      Api::Games::PlatformGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should add platforms to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_platforms_to_game
    platform_ids = @game.platforms.map(&:igdb_id)
    igdb_game_data["platforms"].each { |id| assert platform_ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_platforms_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon platform failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_platform_failures: true,
    )
    @facade.add_platforms_to_game
    ids = igdb_game_data["platforms"]
    @game.errors[:platforms].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end

  test "should add errors to game upon platform_logo failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_platform_logo_failures: true,
    )
    @facade.add_platforms_to_game
    assert_equal(
      @game.errors[:platform_logos].first.count,
      stubbed_platform_logo_ids.count,
    )
  end
end
