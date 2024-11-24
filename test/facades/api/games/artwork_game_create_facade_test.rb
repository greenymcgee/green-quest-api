require "test_helper"

class Api::Games::ArtworkGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @facade =
      Api::Games::ArtworkGameCreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should add artworks to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_artworks_to_game
    ids = @game.artworks.map(&:igdb_id)
    @igdb_game_data["artworks"].each { |id| assert ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_artworks_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon artwork failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_artwork_failures: true,
    )
    @facade.add_artworks_to_game
    ids = @igdb_game_data["artworks"]
    @game.errors[:artworks].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
