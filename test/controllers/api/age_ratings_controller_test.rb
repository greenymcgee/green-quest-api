require "test_helper"

class AgeRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_rating = age_ratings(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_age_ratings_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_age_ratings_url, as: :json
    assert_matches_json_schema response, "age_ratings/index"
  end

  test "#show should show age_rating" do
    get api_age_rating_url(@age_rating), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_age_rating_url(@age_rating), as: :json
    assert_matches_json_schema response, "age_ratings/show"
  end

  test "#destroy should destroy age_rating" do
    assert_difference("AgeRating.count", -1) do
      delete(
        api_age_rating_url(@age_rating),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy age_rating company for non-admin users" do
    delete(
      api_age_rating_url(@age_rating),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
