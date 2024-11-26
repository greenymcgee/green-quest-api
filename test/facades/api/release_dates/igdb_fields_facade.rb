require "test_helper"

class Api::ReleaseDates::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @release_date = ReleaseDate.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/release_dates/514962.json"))
    facade = Api::ReleaseDates::IgdbFieldsFacade.new(@release_date, @igdb_data)
    facade.populate_fields
  end

  test "should populate the category_enum" do
    assert_equal(@release_date.category_enum, @igdb_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@release_date.checksum, @igdb_data["checksum"])
  end

  test "should populate the date" do
    assert_equal(@release_date.date, @igdb_data["date"])
  end

  test "should populate the human_readable" do
    assert_equal(@release_date.human_readable, @igdb_data["human"])
  end

  test "should populate the month" do
    assert_equal(@release_date.month, @igdb_data["month"])
  end

  test "should populate the platform" do
    assert_equal(
      @release_date.platform,
      Platform.find_by(igdb_id: @igdb_data["platform"]),
    )
  end

  test "should populate the region_enum" do
    assert_equal(@release_date.region_enum, @igdb_data["region"])
  end

  test "should populate the year" do
    assert_equal(@release_date.year, @igdb_data["year"])
  end
end
