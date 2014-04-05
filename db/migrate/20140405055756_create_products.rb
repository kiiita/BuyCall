class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :name_read
      t.integer :price
      t.integer :count

      t.timestamps
    end
  end
end
