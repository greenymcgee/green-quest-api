class ChangeGameCategoryEnum < ActiveRecord::Migration[7.2]
  def change
    remove_column :games, :category_enum
    add_column :games, :category_enum, :integer
  end
end
