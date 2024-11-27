class AddGameToWebsites < ActiveRecord::Migration[7.2]
  def change
    add_reference :websites, :game
  end
end
