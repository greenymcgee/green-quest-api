require "test_helper"

class Api::Games::ReleaseDateGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::ReleaseDateGameCreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
    @platform_facade =
      Api::Platforms::CreateFacade.new(
        @igdb_game_data["platforms"],
        @twitch_bearer_token,
      )
  end

  test "should add release_dates to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @platform_facade.find_or_create_platforms
    @facade.add_release_dates_to_game
    ids = @game.release_dates.map(&:igdb_id)
    @igdb_game_data["release_dates"].each { |id| assert ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @platform_facade.find_or_create_platforms
    @facade.add_release_dates_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon release_date failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_release_date_failures: true,
    )
    @facade.add_release_dates_to_game
    ids = @igdb_game_data["release_dates"]
    @game.errors[:release_dates].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
