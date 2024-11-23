require "test_helper"

class Api::AgeRatings::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @ids = JSON.parse(json_mocks("igdb/game.json")).first["age_ratings"]
  end

  test "should create new age_ratings" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "age_ratings/#{id}",
        json_mocks("igdb/age_ratings/#{id}.json"),
        @twitch_oauth_token,
      )
    end
    assert_difference("AgeRating.count", +@ids.count) do
      facade = Api::AgeRatings::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_age_ratings
    end
  end

  test "should not create age ratings when the igdb request fails" do
    @ids.each { |id| stub_igdb_api_request_failure("age_ratings/#{id}") }
    assert_difference("AgeRating.count", +0) do
      facade = Api::AgeRatings::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_age_ratings
    end
  end

  test "should return successfully found or created age ratings" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "age_ratings/#{id}",
        json_mocks("igdb/age_ratings/#{id}.json"),
        @twitch_oauth_token,
      )
    end
    facade = Api::AgeRatings::CreateFacade.new(@ids, @twitch_oauth_token)
    igdb_ids = facade.find_or_create_age_ratings[:age_ratings].map(&:igdb_id)
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed igdb api requests" do
    @ids.each { |id| stub_igdb_api_request_failure("age_ratings/#{id}") }
    facade = Api::AgeRatings::CreateFacade.new(@ids, @twitch_oauth_token)
    errors = facade.find_or_create_age_ratings[:errors]
    errors.each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed age_rating creations" do
    stub_successful_igdb_api_request(
      "age_ratings/#{nil}",
      json_mocks("igdb/age_ratings/49238.json"),
      @twitch_oauth_token,
    )
    facade = Api::AgeRatings::CreateFacade.new([nil], @twitch_oauth_token)
    request = facade.find_or_create_age_ratings
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
