require "test_helper"

class Api::AgeRatings::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @age_rating = AgeRating.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/age_ratings/49238.json"))
    facade = Api::AgeRatings::IgdbFieldsFacade.new(@age_rating, @igdb_data)
    facade.populate_fields
  end

  test "should populate the category_enum" do
    assert_equal(@age_rating.category_enum, @igdb_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@age_rating.checksum, @igdb_data["checksum"])
  end

  test "should populate the rating_enum" do
    assert_equal(@age_rating.rating_enum, @igdb_data["rating"])
  end

  test "should populate the rating_cover_url" do
    assert_equal(@age_rating.rating_cover_url, @igdb_data["rating_cover_url"])
  end

  test "should populate the synopsis" do
    assert_equal(@age_rating.synopsis, @igdb_data["synopsis"])
  end
end
