require "test_helper"

class Api::AgeRatings::IgdbRequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @id = 74_574
    @pathname = "age_ratings/#{@id}"
    @age_rating_json = json_mocks("igdb/age_ratings/49238.json")
  end

  test "should return age rating data upon success" do
    stub_successful_igdb_api_request(
      @pathname,
      @age_rating_json,
      @twitch_oauth_token,
    )
    facade = Api::AgeRatings::IgdbRequestFacade.new(@id, @twitch_oauth_token)
    age_rating = facade.get_igdb_data[:igdb_data]
    assert_equal(age_rating, JSON.parse(@age_rating_json).first)
  end

  test "should return an error when the age rating request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade = Api::AgeRatings::IgdbRequestFacade.new(@id, @twitch_oauth_token)
    error = facade.get_igdb_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
