require "test_helper"

class Api::WebsitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @website = websites(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#should get index" do
    get api_websites_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_websites_url, as: :json
    assert_matches_json_schema response, "websites/index"
  end

  test "#show should show website" do
    get api_website_url(@website), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_website_url(@website), as: :json
    assert_matches_json_schema response, "websites/show"
  end

  test "#destroy should destroy website" do
    assert_difference("Website.count", -1) do
      delete api_website_url(@website), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy website for non-admin users" do
    delete(api_website_url(@website), as: :json, headers: @basic_auth_headers)
    assert_response :forbidden
  end
end
