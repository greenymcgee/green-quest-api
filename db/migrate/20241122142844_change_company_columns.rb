class ChangeCompanyColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :companies, :developed_games
    remove_column :companies, :published_games
    add_column(
      :companies,
      :developed_game_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :companies,
      :published_game_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
  end
end
