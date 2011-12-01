class CreateSwipes < ActiveRecord::Migration
  def change
    create_table :swipes do |t|
      t.integer :user_nnumber
      t.integer :user_id
      t.string  :netid
      t.string  :credential
      t.integer :device_id
      t.integer :app_id
      t.text    :extra

      t.timestamps
    end
  end
end
