class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :tel
      t.string  :name
      t.string  :zip
      t.string  :address1
      t.string  :address2
      t.integer :count
      t.timestamps
    end
  end
end
