require "test_helper"

class Api::FranchisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @franchise = franchises(:the_legend_of_zelda)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#should get index" do
    get api_franchises_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_franchises_url, as: :json
    assert_matches_json_schema response, "franchises/index"
  end

  test "#show should show franchise" do
    get api_franchise_url(@franchise), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_franchise_url(@franchise), as: :json
    assert_matches_json_schema response, "franchises/show"
  end

  test "#destroy should destroy franchise" do
    assert_difference("Franchise.count", -1) do
      delete(
        api_franchise_url(@franchise),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy franchise for non-admin users" do
    delete(
      api_franchise_url(@franchise),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
