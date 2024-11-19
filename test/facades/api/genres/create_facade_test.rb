require "test_helper"

class Api::Genres::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @genre_ids = [9, 31]
  end

  test "should create new genres" do
    @genre_ids.each do |genre_id|
      stub_successful_igdb_api_request(
        "genres/#{genre_id}",
        json_mocks("igdb/genres/#{genre_id}.json"),
        @twitch_oauth_token,
      )
    end
    assert_difference("Genre.count", +1) do
      facade = Api::Genres::CreateFacade.new(@genre_ids, @twitch_oauth_token)
      facade.find_or_create_genres
    end
  end

  test "should not create genres when the igdb request fails" do
    @genre_ids.each do |genre_id|
      stub_igdb_api_request_failure("genres/#{genre_id}")
    end
    assert_difference("Genre.count", +0) do
      facade = Api::Genres::CreateFacade.new(@genre_ids, @twitch_oauth_token)
      facade.find_or_create_genres
    end
  end

  test "should return successfully found or created genres" do
    @genre_ids.each do |genre_id|
      stub_successful_igdb_api_request(
        "genres/#{genre_id}",
        json_mocks("igdb/genres/#{genre_id}.json"),
        @twitch_oauth_token,
      )
    end
    facade = Api::Genres::CreateFacade.new(@genre_ids, @twitch_oauth_token)
    igdb_ids = facade.find_or_create_genres[:genres].map(&:igdb_id)
    assert_equal igdb_ids, @genre_ids
  end

  test "should return errors for any failed igdb api requests" do
    @genre_ids.each do |genre_id|
      stub_igdb_api_request_failure("genres/#{genre_id}")
    end
    facade = Api::Genres::CreateFacade.new(@genre_ids, @twitch_oauth_token)
    error, = facade.find_or_create_genres[:errors]
    assert_equal(
      error,
      { @genre_ids.last => { "message" => "Not authorized" } },
    )
  end

  test "should return errors for any failed genre creations" do
    stub_successful_igdb_api_request(
      "genres/#{nil}",
      json_mocks("igdb/genres/#{9}.json"),
      @twitch_oauth_token,
    )
    facade = Api::Genres::CreateFacade.new([nil], @twitch_oauth_token)
    request = facade.find_or_create_genres
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
