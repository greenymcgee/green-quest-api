require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:super_metroid)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "should get index" do
    get api_games_url, as: :json
    assert_response :success
  end

  test "should return the expected index json payload" do
    get api_games_url, as: :json
    assert_matches_json_schema response, "games/index"
  end

  test "should create game" do
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

  test "should not create game for non-admin users" do
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

  test "should return the expected create json payload" do
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

  test "should show game" do
    get api_game_url(@game), as: :json
    assert_response :success
  end

  test "should return the expected show json payload" do
    get api_game_url(@game), as: :json
    assert_matches_json_schema response, "games/show"
  end

  test "should update game" do
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

  test "should not update game for non-admin users" do
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

  test "should return the expected update json payload" do
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

  test "should destroy game" do
    assert_difference("Game.count", -1) do
      delete api_game_url(@game), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "should not destroy game for non-admin users" do
    delete api_game_url(@game), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
