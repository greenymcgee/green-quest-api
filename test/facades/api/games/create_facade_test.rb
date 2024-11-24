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

  test "should add age ratings to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    age_rating_ids = @game.age_ratings.map(&:igdb_id)
    @igdb_game_data["age_ratings"].each do |id|
      assert age_rating_ids.include? id
    end
  end

  test "should add artworks to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    ids = @game.artworks.map(&:igdb_id)
    @igdb_game_data["artworks"].each { |id| assert ids.include? id }
  end

  test "should add genres to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert_equal(@game.genres.map(&:igdb_id), @igdb_game_data["genres"])
  end

  test "should add platforms to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    platform_ids = @game.platforms.map(&:igdb_id)
    @igdb_game_data["platforms"].each { |id| assert platform_ids.include? id }
  end

  test "should add involved companies to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    involved_company_ids = @game.involved_companies.map(&:igdb_id)
    @igdb_game_data["involved_companies"].each do |id|
      assert involved_company_ids.include? id
    end
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

  test "should add errors to game upon platform failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_platform_failures: true,
    )
    @facade.add_game_resources
    platform_ids = @igdb_game_data["platforms"]
    @game.errors[:platforms].first.each_with_index do |errors, index|
      id = index > 0 ? platform_ids[index + 1] : platform_ids[index]
      assert_equal(errors.first, [id, { "message" => "Not authorized" }])
    end
  end
end
