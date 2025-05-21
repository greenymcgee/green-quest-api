require "test_helper"

class Api::Games::ScreenshotGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::ScreenshotGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::ScreenshotGameRefreshFacade.new(**params)
  end

  test "should refresh game screenshot data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_screenshots_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_screenshots
    igdb_game_data["screenshots"].each do |id|
      screenshot_json =
        JSON.parse(json_mocks("igdb/screenshots/#{id}.refresh.json"))
      game_screenshot = @game.screenshots.find_by(igdb_id: id)
      assert_equal screenshot_json.first["url"], game_screenshot.url
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_screenshots_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_screenshots
    assert_equal igdb_game_data["screenshots"].count, @game.screenshots.count
    assert_equal @game.screenshots.distinct.count, @game.screenshots.count
  end
end
