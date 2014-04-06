class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name,      null: false
      t.string :name_read, null: false
      t.integer :price,    null: false
      t.integer :count,    null: false, default: 1

      t.timestamps
    end
  end
end
