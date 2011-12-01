class CreateDeviceTypes < ActiveRecord::Migration
  def change
    create_table :device_types do |t|
      t.string  :name
      t.text    :description
    end
  end
end
