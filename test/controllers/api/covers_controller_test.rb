require "test_helper"

class Api::CoversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cover = covers(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_covers_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_covers_url, as: :json
    assert_matches_json_schema response, "covers/index"
  end

  test "#show should show cover" do
    get api_cover_url(@cover), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_cover_url(@cover), as: :json
    assert_matches_json_schema response, "covers/show"
  end

  test "#destroy should destroy cover" do
    assert_difference("Cover.count", -1) do
      delete api_cover_url(@cover), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy cover for non-admin users" do
    delete api_cover_url(@cover), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
