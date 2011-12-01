class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :email
      t.string :auth_key, :unique => true
      
      t.timestamps
    end
  end
end
