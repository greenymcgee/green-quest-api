class AddRolesToUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :roles, :string, array: true, default: []
    remove_column :users, :role
  end

  def down
    add_column :users, :role, :string
    remove_column :users, :roles
  end
end
