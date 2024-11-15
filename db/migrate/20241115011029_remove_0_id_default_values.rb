class Remove0IdDefaultValues < ActiveRecord::Migration[7.2]
  def change
    change_column_default :games, :collection_id, nil
    change_column_default :games, :cover_id, nil
    change_column_default :games, :franchise_id, nil
    change_column_default :games, :parent_game_id, nil
    change_column_default :games, :version_parent_id, nil
  end
end
