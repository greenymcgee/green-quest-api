require "test_helper"

class Api::Games::ThemeGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::ThemeGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::ThemeGameRefreshFacade.new(**params)
  end

  test "should refresh game theme data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_themes_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_themes
    igdb_game_data["themes"].each do |id|
      theme_json = JSON.parse(json_mocks("igdb/themes/#{id}.refresh.json"))
      game_theme = @game.themes.find_by(igdb_id: id)
      assert_equal theme_json.first["checksum"], game_theme.checksum
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_themes_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_themes
    assert_equal igdb_game_data["themes"].count, @game.themes.count
    assert_equal @game.themes.distinct.count, @game.themes.count
  end
end
