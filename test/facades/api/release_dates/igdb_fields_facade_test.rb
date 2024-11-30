require "test_helper"

class Api::ReleaseDates::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @release_date = ReleaseDate.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/release_dates/514962.json"))
    @platform = Platform.create(igdb_id: @igdb_data["platform"])
    facade = Api::ReleaseDates::IgdbFieldsFacade.new(@release_date, @igdb_data)
    facade.populate_fields
  end

  test "should populate the category_enum" do
    assert_equal(@release_date.category_enum, @igdb_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@release_date.checksum, @igdb_data["checksum"])
  end

  test "should gracefully handle a null date" do
    release_date = ReleaseDate.new(igdb_id: 40)
    igdb_data = { **@igdb_data, "date" => nil }
    facade = Api::ReleaseDates::IgdbFieldsFacade.new(release_date, igdb_data)
    facade.populate_fields
    assert_nil release_date.date
  end

  test "should populate the date" do
    igdb_date = @igdb_data["date"]
    date = Time.at(igdb_date).utc.to_datetime
    assert_equal(@release_date.date, date)
  end

  test "should populate the human_readable" do
    assert_equal(@release_date.human_readable, @igdb_data["human"])
  end

  test "should populate the month" do
    assert_equal(@release_date.month, @igdb_data["m"])
  end

  test "should populate the platform" do
    assert_equal(@platform, @release_date.platform)
  end

  test "should populate the region_enum" do
    assert_equal(@release_date.region_enum, @igdb_data["region"])
  end

  test "should populate the year" do
    assert_equal(@release_date.year, @igdb_data["y"])
  end
end
