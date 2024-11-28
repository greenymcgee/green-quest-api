require "test_helper"

class Api::Companies::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @company = Company.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/companies/421.json"))
    facade = Api::Companies::IgdbFieldsFacade.new(@company, @igdb_data)
    facade.populate_fields
  end

  test "should populate the change_date" do
    igdb_date = @igdb_data["change_date"]
    date = Time.at(igdb_date).utc.to_datetime
    assert_equal(@company.change_date, date)
  end

  test "should gracefully handle a null change_date" do
    company = Company.new(igdb_id: 40)
    igdb_data = { **@igdb_data, "change_date" => nil }
    facade = Api::Companies::IgdbFieldsFacade.new(company, igdb_data)
    facade.populate_fields
    assert_nil(company.change_date)
  end

  test "should populate the change_date_category_enum" do
    assert_equal(
      @company.change_date_category_enum,
      @igdb_data["change_date_category"],
    )
  end

  test "should populate the changed_company_id" do
    assert_equal(@company.changed_company_id, @igdb_data["changed_company_id"])
  end

  test "should populate the checksum" do
    assert_equal(@company.checksum, @igdb_data["checksum"])
  end

  test "should populate the country_code" do
    assert_equal(@company.country_code, @igdb_data["country"])
  end

  test "should populate the description" do
    assert_equal(@company.description, @igdb_data["description"])
  end

  test "should populate the developed_game_ids" do
    assert_equal(@company.developed_game_ids, @igdb_data["developed"])
  end

  test "should populate the igdb_url" do
    assert_equal(@company.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@company.name, @igdb_data["name"])
  end

  test "should populate the parent_id" do
    assert_equal(@company.parent_id, @igdb_data["parent"])
  end

  test "should populate the slug" do
    assert_equal(@company.slug, @igdb_data["slug"])
  end

  test "should gracefully handle a null start_date" do
    company = Company.new(igdb_id: 40)
    igdb_data = { **@igdb_data, "start_date" => nil }
    facade = Api::Companies::IgdbFieldsFacade.new(company, igdb_data)
    facade.populate_fields
    assert_nil company.start_date
  end

  test "should populate the start_date" do
    igdb_date = @igdb_data["start_date"]
    date = Time.at(igdb_date).utc.to_datetime
    assert_equal(@company.start_date, date)
  end
end
