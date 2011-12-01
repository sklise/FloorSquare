class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :nnumber
      t.string :netid
      t.string :name
      t.string :photo
      t.text   :extra

      t.timestamps
    end
  end

end
