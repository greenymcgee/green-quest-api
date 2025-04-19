require "test_helper"

class Api::HomeCarouselsControllerTest < ActionDispatch::IntegrationTest
  test "#show should show artwork" do
    get api_home_carousel_url("snes"), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_home_carousel_url("snes"), as: :json
    assert_matches_json_schema response, "home_carousels/show"
  end
end
