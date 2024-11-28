require "test_helper"

class Api::CompanyLogosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_logo = company_logos(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_company_logos_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_company_logos_url, as: :json
    assert_matches_json_schema response, "company_logos/index"
  end

  test "#show should show company_logo" do
    get api_company_logo_url(@company_logo), as: :json
    assert_response :success
  end

  test "#destroy should destroy company_logo" do
    assert_difference("CompanyLogo.count", -1) do
      delete(
        api_company_logo_url(@company_logo),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy company_logo for non-admin users" do
    delete(
      api_company_logo_url(@company_logo),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
