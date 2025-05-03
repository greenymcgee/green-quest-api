require "test_helper"

class Api::Games::IndexFacadeTest < ActiveSupport::TestCase
  test "should return all games when no published param is passed" do
    facade = Api::Games::IndexFacade.new({})
    assert_equal facade.games, Game.all.order(name: :asc)
  end

  test "should only return published games when published param is truthy" do
    facade = Api::Games::IndexFacade.new({ published: true })
    expectation =
      games.select do |game|
        game.published_at.present? && game.published_at <= Time.current
      end
    assert_equal facade.games, expectation
  end
end
