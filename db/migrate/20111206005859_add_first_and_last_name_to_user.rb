class AddFirstAndLastNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :first, :string
    add_column :users, :last, :string
    remove_column :users, :name
  end
end
