require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "valid company" do
    company = Company.new(igdb_id: 10)
    assert company.valid?
  end

  test "invalid without igdb_id" do
    company = Company.new()
    company.valid?
    assert company.errors[:igdb_id].include? "can't be blank"
  end
end
