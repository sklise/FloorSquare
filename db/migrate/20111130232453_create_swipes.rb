class CreateSwipes < ActiveRecord::Migration
  def self.up
    create_table :swipes do |t|
      t.integer :user_nnumber
      t.string  :netid
      t.string  :credential
      t.integer :device_id
      t.integer :app_id
      t.text    :extra

      t.timestamps
    end
  end

  def self.down
  end
end
