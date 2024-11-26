require "test_helper"

class ReleaseDateTest < ActiveSupport::TestCase
  test "valid release_date" do
    release_date =
      ReleaseDate.new(
        game: games(:super_metroid),
        igdb_id: 10,
        platform: platforms(:snes),
      )
    assert release_date.valid?
  end

  test "invalid without igdb_id" do
    release_date = ReleaseDate.new()
    release_date.valid?
    assert release_date.errors[:igdb_id].include? "can't be blank"
  end

  test "delegate platform name" do
    release_date = release_dates(:one)
    assert_equal(release_date.platform_name, release_date.platform.name)
  end
end
