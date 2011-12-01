class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :nnumber
      t.string :netid
      t.string :name
      t.string :photo
      t.text   :extra

      t.timestamps
    end
  end

  def self.down
  end
end
