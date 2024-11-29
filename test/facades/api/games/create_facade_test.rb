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

  test "should add a cover to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert_equal @game.cover.igdb_id, @igdb_game_data["cover"]
  end

  test "should add franchises to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    ids = @game.franchises.map(&:igdb_id)
    @igdb_game_data["franchises"].each { |id| assert ids.include? id }
  end

  test "should add game_engines to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert_equal(
      @game.game_engines.map(&:igdb_id),
      @igdb_game_data["game_engines"],
    )
  end

  test "should add game_modes to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert_equal(@game.game_modes.map(&:igdb_id), @igdb_game_data["game_modes"])
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

  test "should add release_dates to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    ids = @game.release_dates.map(&:igdb_id)
    @igdb_game_data["release_dates"].each { |id| assert ids.include? id }
  end

  test "should add screenshots to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    ids = @game.screenshots.map(&:igdb_id)
    @igdb_game_data["screenshots"].each { |id| assert ids.include? id }
  end

  test "should add websites to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    ids = @game.websites.map(&:igdb_id)
    @igdb_game_data["websites"].each { |id| assert ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_game_resources
    assert @game.errors.blank?
  end

  test "should add errors to game upon platform failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_platform_failures: true,
    )
    @facade.add_game_resources
    platform_ids = @igdb_game_data["platforms"]
    @game.errors[:platforms].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [platform_ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
