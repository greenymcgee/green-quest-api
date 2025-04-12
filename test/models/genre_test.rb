require "test_helper"

class GenreTest < ActiveSupport::TestCase
  test "valid genre" do
    genre = Genre.new(igdb_id: 10)
    assert genre.valid?
  end

  test "invalid without igdb_id" do
    genre = Genre.new()
    genre.valid?
    assert genre.errors[:igdb_id].include? "can't be blank"
  end

  test "#with_games" do
    with_games = Genre.with_games
    expectation = Genre.all.select { |genre| genre.games.count != 0 }
    with_games.each { |genre| assert expectation.include? genre }
  end
end
