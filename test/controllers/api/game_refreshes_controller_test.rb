require "test_helper"

class Api::GameRefreshesControllerTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include TwitchOauthTestHelper
  include GameRefreshTestHelper

  setup do
    @game = games(:super_metroid)
    @admin_user = users(:admin_user)
    @auth_headers = set_auth_headers(@admin_user)
  end

  test "#create should return 401 when not authenticated" do
    post refresh_api_game_url(@game.slug), as: :json
    assert_response :unauthorized
  end

  test "#create should return 422 when IGDB request fails" do
    stub_successful_twitch_oauth_request
    stub_igdb_api_request_failure("games/#{@game.igdb_id}")
    post refresh_api_game_url(@game.slug), headers: @auth_headers, as: :json
    assert_response :unprocessable_entity
  end

  test "#create should return 207 when resources are added but errors are present" do
    stub_successful_game_refresh_request(
      @game.igdb_id,
      with_platform_failures: true,
    )
    post refresh_api_game_url(@game.slug), headers: @auth_headers, as: :json
    assert_response :multi_status
  end

  test "#create should return 201 when game is refreshed successfully" do
    stub_successful_game_refresh_request(@game.igdb_id)
    post refresh_api_game_url(@game.slug), headers: @auth_headers, as: :json
    assert_response :created
  end
end
