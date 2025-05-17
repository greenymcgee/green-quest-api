require "test_helper"

class Api::Games::ArtworkGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::ArtworkGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::ArtworkGameRefreshFacade.new(**params)
  end

  test "should refresh game artwork data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_artworks_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_artworks
    igdb_game_data["artworks"].each do |id|
      artwork_json = JSON.parse(json_mocks("igdb/artworks/#{id}.refresh.json"))
      game_artwork = @game.artworks.find_by(igdb_id: id)
      assert_equal artwork_json.first["url"], game_artwork.url
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_artworks_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_artworks
    assert_equal igdb_game_data["artworks"].count, @game.artworks.count
    assert_equal @game.artworks.distinct.count, @game.artworks.count
  end
end
