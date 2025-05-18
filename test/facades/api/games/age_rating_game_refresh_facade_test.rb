require "test_helper"

class Api::Games::AgeRatingGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    params = {
      game: @game,
      igdb_game_data: @igdb_game_data,
      twitch_bearer_token: @twitch_bearer_token,
    }
    @create_facade = Api::Games::AgeRatingGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::AgeRatingGameRefreshFacade.new(**params)
  end

  test "should refresh game age_rating data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_age_ratings_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_age_ratings
    igdb_game_data["age_ratings"].each do |id|
      age_rating_json =
        JSON.parse(json_mocks("igdb/age_ratings/#{id}.refresh.json"))
      game_age_rating = @game.age_ratings.find_by(igdb_id: id)
      assert_equal age_rating_json.first["checksum"], game_age_rating.checksum
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_age_ratings_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_age_ratings
    assert_equal igdb_game_data["age_ratings"].count, @game.age_ratings.count
    assert_equal @game.age_ratings.distinct.count, @game.age_ratings.count
  end
end
