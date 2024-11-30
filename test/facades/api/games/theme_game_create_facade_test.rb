require "test_helper"

class Api::Games::ThemeGameCreateFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @facade =
      Api::Games::ThemeGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should add themes to the game" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_themes_to_game
    ids = @game.themes.map(&:igdb_id)
    igdb_game_data["themes"].each { |id| assert ids.include? id }
  end

  test "should not add errors to game upon success" do
    stub_successful_game_create_request(@game.igdb_id)
    @facade.add_themes_to_game
    assert @game.errors.blank?
  end

  test "should add errors to game upon theme failure" do
    stub_successful_game_create_request(
      @game.igdb_id,
      with_theme_failures: true,
    )
    @facade.add_themes_to_game
    ids = igdb_game_data["themes"]
    @game.errors[:themes].first.each_with_index do |errors, index|
      assert_equal(
        errors.first,
        [ids[index], { "message" => "Not authorized" }],
      )
    end
  end
end
