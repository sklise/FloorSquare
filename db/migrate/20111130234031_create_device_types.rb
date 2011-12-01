class CreateDeviceTypes < ActiveRecord::Migration
  def self.up
    create_table :device_types do |t|
      t.string  :name
      t.text    :description
    end
  end

  def self.down
  end
end
