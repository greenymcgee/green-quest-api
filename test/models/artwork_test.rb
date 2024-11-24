require "test_helper"

class ArtworkTest < ActiveSupport::TestCase
  test "valid artwork" do
    artwork = Artwork.new(igdb_id: 10)
    assert artwork.valid?
  end

  test "invalid without igdb_id" do
    artwork = Artwork.new()
    artwork.valid?
    assert artwork.errors[:igdb_id].include? "can't be blank"
  end
end
