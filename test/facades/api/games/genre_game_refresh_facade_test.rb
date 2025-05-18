require "test_helper"

class Api::Games::GenreGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::GenreGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::GenreGameRefreshFacade.new(**params)
  end

  test "should refresh genre data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_genres_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_genres
    igdb_game_data["genres"].each do |id|
      genre_json = JSON.parse(json_mocks("igdb/genres/#{id}.refresh.json"))
      game_genre = @game.genres.find_by(igdb_id: id)
      assert_equal genre_json.first["slug"], game_genre.slug
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_genres_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_genres
    assert_equal igdb_game_data["genres"].count, @game.genres.count
    assert_equal @game.genres.distinct.count, @game.genres.count
  end
end
