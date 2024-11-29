require "test_helper"

class FranchiseTest < ActiveSupport::TestCase
  test "valid franchise" do
    franchise = Franchise.new(igdb_id: 10)
    assert franchise.valid?
  end

  test "invalid without igdb_id" do
    franchise = Franchise.new()
    franchise.valid?
    assert franchise.errors[:igdb_id].include? "can't be blank"
  end
end
