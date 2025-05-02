require "test_helper"

class Api::GamePublishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:super_metroid)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#create should publish a game when it is publishable" do
    frozen_time = Time.zone.local(2024, 1, 1, 12, 0, 0)
    travel_to(frozen_time) do
      @game.assign_attributes(
        estimated_first_played_date: Date.new(2020, 1, 1),
        featured_video_id: "abc123",
        igdb_id: 4848,
        last_played_date: Date.new(2021, 1, 1),
        review: "Solid game.",
        review_title: "Legend reborn",
        rating: 90,
      )
      @game.banner_image =
        fixture_file_upload("banner_image.webp", "image/webp")
      @game.save!
      post publish_api_game_url(@game.slug), headers: @admin_auth_headers
      assert_response :ok
      assert_equal frozen_time, @game.reload.published_at
    end
  end

  test "#create should not publish a game when it is not publishable" do
    post publish_api_game_url(@game.slug), headers: @admin_auth_headers
    assert_response :unprocessable_entity
  end

  test "#create should return the expected unpublishable payload" do
    post publish_api_game_url(@game.slug), headers: @admin_auth_headers
    assert_matches_json_schema response, "game_publishes/unpublishable_game"
  end

  test "#create should return unpublishable reasons" do
    post publish_api_game_url(@game.slug), headers: @admin_auth_headers
    facade = PublishableGameFacade.new(@game)
    facade.unpublishable_reasons.each do |reason|
      assert_includes(response.parsed_body["unpublishableReasons"], reason)
    end
  end

  test "#create should not create for non-admin users" do
    post publish_api_game_url(@game.slug), headers: @basic_auth_headers
    assert_response :forbidden
  end

  test "#destroy should destroy published_at date" do
    delete publish_api_game_url(@game.slug), headers: @admin_auth_headers
    assert_response :ok
    assert_nil @game.published_at
  end

  test "#destroy should not destroy for non-admin users" do
    delete publish_api_game_url(@game.slug), headers: @basic_auth_headers
    assert_response :forbidden
  end
end
