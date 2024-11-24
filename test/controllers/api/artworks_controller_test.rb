require "test_helper"

class Api::ArtworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artwork = artworks(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_artworks_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_artworks_url, as: :json
    assert_matches_json_schema response, "artworks/index"
  end

  test "#show should show artwork" do
    get api_artwork_url(@artwork), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_artwork_url(@artwork), as: :json
    assert_matches_json_schema response, "artworks/show"
  end
  test "#destroy should destroy artwork" do
    assert_difference("Artwork.count", -1) do
      delete api_artwork_url(@artwork), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy artwork company for non-admin users" do
    delete(api_artwork_url(@artwork), as: :json, headers: @basic_auth_headers)
    assert_response :forbidden
  end
end
