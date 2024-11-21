require "test_helper"

class InvolvedCompanyTest < ActiveSupport::TestCase
  test "valid involved_company" do
    involved_company =
      InvolvedCompany.new(
        company_id: companies(:nintendo).id,
        game_id: games(:super_metroid).id,
        igdb_id: 10,
      )
    assert involved_company.valid?
  end

  test "invalid without igdb_id" do
    involved_company = InvolvedCompany.new()
    involved_company.valid?
    assert involved_company.errors[:igdb_id].include? "can't be blank"
  end
end
