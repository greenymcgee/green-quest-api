require "test_helper"

class Api::Games::RefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @create_facade =
      Api::Games::CreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::RefreshFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should refresh age_ratings" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.age_ratings.each do |age_rating|
      assert age_rating.checksum.include?("refresh")
    end
  end

  test "should refresh artworks" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.artworks.each { |artwork| assert artwork.url.include?("refresh") }
  end

  test "should refresh the cover" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    assert @game.cover.reload.url.include?("refresh")
  end

  test "should refresh franchises" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.franchises.each do |franchise|
      assert franchise.slug.include?("refreshed")
    end
  end

  test "should refresh game_engines" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.game_engines.each do |game_engine|
      assert game_engine.slug.include?("refreshed")
    end
  end

  test "should refresh game_modes" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.game_modes.each do |game_mode|
      assert game_mode.slug.include?("refreshed")
    end
  end

  test "should refresh game_videos" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.game_videos.each do |game_video|
      assert game_video.checksum.include?("refreshed")
    end
  end

  test "should refresh genres" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.genres.each { |genre| assert genre.slug.include?("refreshed") }
  end

  test "should refresh platforms" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.platforms.each do |platform|
      assert platform.slug.include?("refreshed")
    end
  end

  test "should refresh player_perspectives" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.player_perspectives.each do |player_perspective|
      assert player_perspective.slug.include?("refreshed")
    end
  end

  test "should refresh involved_companies" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.involved_companies.each do |involved_company|
      assert involved_company.checksum.include?("refresh")
    end
  end
end
