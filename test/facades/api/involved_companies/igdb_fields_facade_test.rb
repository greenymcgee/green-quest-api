require "test_helper"

class Api::InvolvedCompanies::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @involved_company =
      InvolvedCompany.new(
        company: companies(:nintendo),
        igdb_id: 1026,
        game: games(:super_metroid),
      )
    @igdb_data, = JSON.parse(json_mocks("igdb/involved_companies/101094.json"))
    facade =
      Api::InvolvedCompanies::IgdbFieldsFacade.new(
        @involved_company,
        @igdb_data,
      )
    facade.populate_involved_company_fields
  end

  test "should populate the is_developer" do
    assert_equal(@involved_company.is_developer, @igdb_data["developer"])
  end

  test "should populate the is_porter" do
    assert_equal(@involved_company.is_porter, @igdb_data["porting"])
  end

  test "should populate the is_publisher" do
    assert_equal(@involved_company.is_publisher, @igdb_data["publisher"])
  end

  test "should populate the is_supporter" do
    assert_equal(@involved_company.is_supporter, @igdb_data["supporting"])
  end
end
