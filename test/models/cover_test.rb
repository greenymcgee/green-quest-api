require "test_helper"

class CoverTest < ActiveSupport::TestCase
  test "valid cover" do
    cover = Cover.new(igdb_id: 10)
    assert cover.valid?
  end

  test "invalid without igdb_id" do
    cover = Cover.new()
    cover.valid?
    assert cover.errors[:igdb_id].include? "can't be blank"
  end
end
