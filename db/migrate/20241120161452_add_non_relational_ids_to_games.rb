class AddNonRelationalIdsToGames < ActiveRecord::Migration[7.2]
  def change
    add_column(
      :games,
      :bundle_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :dlc_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :expanded_game_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :expansion_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :fork_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(:games, :parent_game_id, :integer)
    add_column(
      :games,
      :port_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :remake_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :remaster_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :similar_game_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(
      :games,
      :standalone_expansion_ids,
      :integer,
      array: true,
      default: [],
      null: false,
    )
    add_column(:games, :version_parent_id, :integer)
  end
end
