require "test_helper"

class Api::GameVideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_video = game_videos(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_game_videos_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_game_videos_url, as: :json
    assert_matches_json_schema response, "game_videos/index"
  end

  test "#show should show game_video" do
    get api_game_video_url(@game_video), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_game_video_url(@game_video), as: :json
    assert_matches_json_schema response, "game_videos/show"
  end
  test "#destroy should destroy game_video" do
    assert_difference("GameVideo.count", -1) do
      delete(
        api_game_video_url(@game_video),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy game_video for non-admin users" do
    delete(
      api_game_video_url(@game_video),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
