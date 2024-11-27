require "test_helper"

class Api::Games::AgeRatingGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @facade =
      Api::Games::AgeRatingGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should add age ratings to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_age_ratings_to_game
    age_rating_ids = @game.age_ratings.map(&:igdb_id)
    igdb_game_data["age_ratings"].each do |id|
      assert age_rating_ids.include? id
    end
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_age_ratings_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon age rating failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_age_rating_failures: true,
    )
    @facade.add_age_ratings_to_game
    ids = igdb_game_data["age_ratings"]
    @game.errors[:age_ratings].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
