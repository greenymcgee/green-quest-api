require "test_helper"

class AgeRatingTest < ActiveSupport::TestCase
  test "valid age_rating" do
    age_rating = AgeRating.new(igdb_id: 10)
    assert age_rating.valid?
  end

  test "invalid without igdb_id" do
    age_rating = AgeRating.new()
    age_rating.valid?
    assert age_rating.errors[:igdb_id].include? "can't be blank"
  end
end
