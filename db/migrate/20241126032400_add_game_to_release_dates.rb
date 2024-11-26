class AddGameToReleaseDates < ActiveRecord::Migration[7.2]
  def change
    add_reference :release_dates, :game
  end
end
