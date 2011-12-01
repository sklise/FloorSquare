class AddUserIdToSwipe < ActiveRecord::Migration
  def change
    add_column :swipes, :user_id, :integer
  end

  def self.down
  end
end
