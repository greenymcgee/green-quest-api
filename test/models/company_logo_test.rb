require "test_helper"

class CompanyLogoTest < ActiveSupport::TestCase
  test "valid company_logo" do
    company_logo = CompanyLogo.new(company: companies(:sony), igdb_id: 10)
    assert company_logo.valid?
  end

  test "invalid without igdb_id" do
    company_logo = CompanyLogo.new()
    company_logo.valid?
    assert company_logo.errors[:igdb_id].include? "can't be blank"
  end
end
