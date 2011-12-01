class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.string :name
      t.string :email
      t.string :auth_key, :unique => true
      
      t.timestamps
    end
  end

  def self.down
  end
end
