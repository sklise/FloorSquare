class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.string  :auth_key, :unique => true
      t.string  :location
      t.integer :device_type_id

      t.timestamps
    end
  end

  def self.down
  end
end
