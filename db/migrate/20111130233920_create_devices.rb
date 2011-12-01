class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string  :auth_key, :unique => true
      t.string  :location
      t.integer :device_type_id

      t.timestamps
    end
  end
end
