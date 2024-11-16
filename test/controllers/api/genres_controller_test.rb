require "test_helper"

class GenresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @genre = genres(:rpg)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_genres_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_genres_url, as: :json
    assert_matches_json_schema response, "genres/index"
  end

  test "#show should show genre" do
    get api_genre_url(@genre), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_genre_url(@genre), as: :json
    assert_matches_json_schema response, "genres/show"
  end

  test "#destroy should destroy genre" do
    assert_difference("Genre.count", -1) do
      delete api_genre_url(@genre), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy genre for non-admin users" do
    delete api_genre_url(@genre), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
