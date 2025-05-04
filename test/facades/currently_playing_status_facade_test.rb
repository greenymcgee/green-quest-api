require "test_helper"

class CurrentlyPlayingStatusFacadeTest < ActiveSupport::TestCase
  test "should set last_played_date when param is truthy" do
    current_game = games(:threads_of_fate)
    params = { currently_playing: true, last_played_date: "1987-01-01" }
    CurrentlyPlayingStatusFacade.call(current_game, params)
    assert_equal Date.today, current_game.last_played_date
  end

  test "should unset previous currently playing game when param is truthy" do
    previous_game = games(:super_metroid)
    current_game = games(:threads_of_fate)
    params = { currently_playing: true, last_played_date: "1987-01-01" }
    CurrentlyPlayingStatusFacade.call(current_game, params)
    refute previous_game.reload.currently_playing
  end

  test "should delete the last_played_date param" do
    current_game = games(:threads_of_fate)
    params = { currently_playing: true, last_played_date: "1987-01-01" }
    CurrentlyPlayingStatusFacade.call(current_game, params)
    assert_nil params[:last_played_date]
  end

  test "should do nothing when currently_playing param is falsey" do
    game = games(:super_metroid)
    assert_no_changes -> { game.reload.last_played_date } do
      CurrentlyPlayingStatusFacade.call(game, { currently_playing: false })
    end
  end

  test "should do nothing when currently_playing param is true and game is already set to currently playing" do
    game = games(:super_metroid)
    assert_no_changes -> { game.reload.last_played_date } do
      CurrentlyPlayingStatusFacade.call(game, { currently_playing: true })
    end
  end

  test "should return reason string when trying to mark an unpublished game as currently playing" do
    result =
      CurrentlyPlayingStatusFacade.call(
        games(:dark_souls),
        { currently_playing: true },
      )
    assert_equal "Cannot mark an unpublished game as currently playing", result
  end
end
