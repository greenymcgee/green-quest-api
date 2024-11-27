require "test_helper"

class WebsiteTest < ActiveSupport::TestCase
  test "valid website" do
    website = Website.new(game: games(:super_metroid), igdb_id: 10)
    assert website.valid?
  end

  test "invalid without igdb_id" do
    website = Website.new()
    website.valid?
    assert website.errors[:igdb_id].include? "can't be blank"
  end
end
