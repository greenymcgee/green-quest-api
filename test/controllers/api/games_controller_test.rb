require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include TwitchOauthTestHelper
  include GameCreateTestHelper

  setup do
    @game = games(:super_metroid)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
    @game_json = json_mocks("igdb/game.json")
    @twitch_bearer_token = stubbed_twitch_bearer_token
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
    stub_successful_game_create_request(1026)
    assert_difference("Game.count") do
      post(
        api_games_url,
        as: :json,
        headers: @admin_auth_headers,
        params: {
          game: {
            igdb_id: 1026,
            rating: 5,
            review: "<p>rich text</p>",
          },
        },
      )
    end
    assert_response :created
  end

  test "#create should return multi status response with genre failures" do
    stub_successful_game_create_request(1026, with_genre_failures: true)
    assert_difference("Game.count") do
      post(
        api_games_url,
        as: :json,
        headers: @admin_auth_headers,
        params: {
          game: {
            igdb_id: 1026,
          },
        },
      )
    end
    assert_response :multi_status
  end

  test "#create should return multi status response with platform failures" do
    stub_successful_game_create_request(1026, with_platform_failures: true)
    assert_difference("Game.count") do
      post(
        api_games_url,
        as: :json,
        headers: @admin_auth_headers,
        params: {
          game: {
            igdb_id: 1026,
          },
        },
      )
    end
    assert_response :multi_status
  end

  test "#create should return a game error" do
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request("games/", @game_json, @twitch_bearer_token)
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

  test "#create should render an unprocessable_entity when the game already exists" do
    igdb_id = games(:super_metroid).igdb_id
    stub_successful_game_create_request(igdb_id)
    post(
      api_games_url,
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: igdb_id,
          rating: 5,
          review: "<p>rich text</p>",
        },
      },
    )
    assert_response :unprocessable_entity
  end

  test "#create should return the expected create json payload" do
    stub_successful_game_create_request(1026)
    post(
      api_games_url,
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: 1026,
          rating: 5,
          review: "<p>rich text</p>",
        },
      },
    )
    assert_matches_json_schema response, "games/create"
  end

  test "#show should show game" do
    get api_game_url(@game.slug), as: :json
    assert_response :success
  end

  test "#show should return a 404 when a game isn't found" do
    get api_game_url("nothing"), as: :json
    assert_response :not_found
  end

  test "#show should return the expected show json payload" do
    get api_game_url(@game.slug), as: :json
    assert_matches_json_schema response, "games/show"
  end

  test "#update should update game" do
    patch(
      api_game_url(@game.slug),
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

  test "#update should not update igdb_id" do
    patch(
      api_game_url(@game.slug),
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          igdb_id: 989,
        },
      },
    )
    assert_equal @game.igdb_id, 47
  end

  test "#update should return an error" do
    patch(
      api_game_url(@game.slug),
      as: :json,
      headers: @admin_auth_headers,
      params: {
      },
    )
    assert_response :bad_request
  end

  test "#update should not update game for non-admin users" do
    patch(
      api_game_url(@game.slug),
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
      api_game_url(@game.slug),
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

  test "#update should set currently playing game and unset any previous one" do
    old_current = games(:super_metroid)
    new_current = games(:threads_of_fate)
    patch(
      api_game_url(new_current.slug),
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          currently_playing: true,
        },
      },
    )
    assert new_current.reload.currently_playing
    refute old_current.reload.currently_playing
  end

  test "#update should not set currently playing when param is false" do
    old_current = games(:super_metroid)
    unset_current = games(:threads_of_fate)
    patch(
      api_game_url(unset_current.slug),
      as: :json,
      headers: @admin_auth_headers,
      params: {
        game: {
          currently_playing: false,
        },
      },
    )
    refute unset_current.reload.currently_playing
    assert old_current.reload.currently_playing
  end

  test "#destroy should destroy game" do
    assert_difference("Game.count", -1) do
      delete api_game_url(@game.slug), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy game for non-admin users" do
    delete api_game_url(@game.slug), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
