require "test_helper"

class Api::Genres::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include TwitchOauthTestHelper
  include GenreCreateTestHelper

  setup do
    @genre_ids = igdb_game_data["genres"]
    @facade =
      Api::Genres::CreateFacade.new(@genre_ids, stubbed_twitch_bearer_token)
  end

  test "should create new genres" do
    stub_successful_genre_responses
    assert_difference("Genre.count", +1) { @facade.find_or_create_genres }
  end

  test "should not create genres when the igdb request fails" do
    stub_genre_request_failures
    assert_difference("Genre.count", +0) { @facade.find_or_create_genres }
  end

  test "should return successfully found or created genres" do
    stub_successful_genre_responses
    igdb_ids = @facade.find_or_create_genres[:genres].map(&:igdb_id)
    assert_equal igdb_ids, @genre_ids
  end

  test "should return errors for any failed igdb api requests" do
    stub_genre_request_failures
    error, = @facade.find_or_create_genres[:errors]
    assert_equal(
      error,
      { @genre_ids.last => { "message" => "Not authorized" } },
    )
  end

  test "should return errors for any failed genre creations" do
    stub_successful_igdb_api_request(
      "genres/#{nil}",
      json_mocks("igdb/genres/#{9}.json"),
      stubbed_twitch_bearer_token,
    )
    facade = Api::Genres::CreateFacade.new([nil], stubbed_twitch_bearer_token)
    request = facade.find_or_create_genres
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
