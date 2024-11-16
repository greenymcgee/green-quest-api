require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  setup do
    @game = games(:super_metroid)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
    @igdb_game_data = json_mocks("igdb/game.json")
    @twitch_bearer_token = "Bearer #{twitch_oauth_access_token}"
  end

  test "#index should get index" do
    get api_games_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_games_url, as: :json
    assert_matches_json_schema response, "games/index"
  end

  test "#create should create game" do
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/40",
      @igdb_game_data,
      @twitch_bearer_token,
    )
    assert_difference("Game.count") do
      post(
        api_games_url,
        as: :json,
        headers: @admin_auth_headers,
        params: {
          game: {
            igdb_id: 40,
            rating: 5,
            review: "<p>rich text</p>",
          },
        },
      )
    end
    assert_response :created
  end

  test "#create should return a game error" do
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/",
      @igdb_game_data,
      @twitch_bearer_token,
    )
    post(
      api_games_url,
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          rating: 1.1,
        },
      },
    )
    assert_response :unprocessable_entity
  end

  test "#create should return a twitch oauth error" do
    stub_twitch_oauth_request_failure
    post(
      api_games_url,
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: 40,
        },
      },
    )
    assert_response :unprocessable_entity
  end

  test "#create should return an igdb api error" do
    stub_successful_twitch_oauth_request
    stub_igdb_api_request_failure ("games/40")
    post(
      api_games_url,
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: 40,
        },
      },
    )
    assert_response :unprocessable_entity
  end

  test "#create should not create game for non-admin users" do
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/40",
      @igdb_game_data,
      @twitch_bearer_token,
    )
    post(
      api_games_url,
      as: :json,
      headers: @basic_auth_headers,
      params: {
        game: {
          igdb_id: @game.igdb_id,
          rating: 5,
          review: "<p>rich text</p>",
        },
      },
    )
    assert_response :forbidden
  end

  test "#create should return the expected create json payload" do
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/40",
      @igdb_game_data,
      @twitch_bearer_token,
    )
    post(
      api_games_url,
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: 40,
          rating: 5,
          review: "<p>rich text</p>",
        },
      },
    )
    assert_matches_json_schema response, "games/create"
  end

  test "#show should show game" do
    get api_game_url(@game), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_game_url(@game), as: :json
    assert_matches_json_schema response, "games/show"
  end

  test "#update should update game" do
    patch(
      api_game_url(@game),
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: @game.igdb_id,
          rating: 5,
          review: "<p>Long rich text review</p>",
        },
      },
    )
    assert_response :success
  end

  test "#update should return an error" do
    patch(
      api_game_url(@game),
      as: :json,
      headers: @admin_auth_headers,
      params: {
      },
    )
    assert_response :bad_request
  end

  test "#update should not update game for non-admin users" do
    patch(
      api_game_url(@game),
      as: :json,
      headers: @basic_auth_headers,
      params: {
        game: {
        },
      },
    )
    assert_response :forbidden
  end

  test "#update should return the expected update json payload" do
    patch(
      api_game_url(@game),
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: @game.igdb_id,
          rating: 5,
          review: "<p>Long rich text review</p>",
        },
      },
    )
    assert_matches_json_schema response, "games/update"
  end

  test "#destroy should destroy game" do
    assert_difference("Game.count", -1) do
      delete api_game_url(@game), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy game for non-admin users" do
    delete api_game_url(@game), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
