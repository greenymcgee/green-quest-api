require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:nintendo)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_companies_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_companies_url, as: :json
    assert_matches_json_schema response, "companies/index"
  end

  test "#show should show company" do
    get api_company_url(@company), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_company_url(@company), as: :json
    assert_matches_json_schema response, "companies/show"
  end

  test "#destroy should destroy company" do
    assert_difference("Company.count", -1) do
      delete api_company_url(@company), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy company for non-admin users" do
    delete api_company_url(@company), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
