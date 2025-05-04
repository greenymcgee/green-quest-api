require "test_helper"

class Api::Games::UpdateFacadeTest < ActiveSupport::TestCase
  test "should return :ok and persist changes when update is successful" do
    game = games(:threads_of_fate)
    update_params = {
      review: "<b>Great game</b>",
      currently_playing: true,
      last_played_date: "1987-01-01",
    }
    result = Api::Games::UpdateFacade.call(game, update_params)
    assert_equal :ok, result
    assert_equal update_params[:review], game.review
    assert_equal Date.today, game.last_played_date
  end

  test "should return reasons array when CurrentlyPlayingStatusFacade fails" do
    game = games(:dark_souls)
    game.update!(published_at: nil)
    update_params = { currently_playing: true }
    result = Api::Games::UpdateFacade.call(game, update_params)
    assert_equal(
      ["Cannot mark an unpublished game as currently playing"],
      result,
    )
  end

  test "should sanitize review content" do
    game = games(:threads_of_fate)
    update_params = {
      review: "<script>alert('bad')</script>",
      currently_playing: false,
    }
    result = Api::Games::UpdateFacade.call(game, update_params)
    assert_equal :ok, result
    assert_equal "alert('bad')", game.review
  end
end
