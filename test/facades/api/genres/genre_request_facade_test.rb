require "test_helper"

class Api::Genres::GenreRequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @genre_id = 2
    @pathname = pathname = "genres/#{@genre_id}"
    @genre_json = json_mocks("igdb/genres/9.json")
  end

  test "should return genre data upon success" do
    stub_successful_igdb_api_request(
      @pathname,
      @genre_json,
      @twitch_oauth_token,
    )
    facade = Api::Genres::GenreRequestFacade.new(@genre_id, @twitch_oauth_token)
    genre = facade.get_igdb_genre_data[:igdb_genre_data]
    assert_equal(genre, JSON.parse(@genre_json).first)
  end

  test "should return an error when the genre request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade = Api::Genres::GenreRequestFacade.new(@genre_id, @twitch_oauth_token)
    error = facade.get_igdb_genre_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
