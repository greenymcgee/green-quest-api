class AddPlatformToReleaseDates < ActiveRecord::Migration[7.2]
  def change
    add_reference :release_dates, :platform
  end
end
