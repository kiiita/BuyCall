class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id   , null: false
      t.integer :product_id, null: false
      t.integer :count,      null: false, default: 1
      t.boolean :confirm_finished, default: false

      t.timestamps
    end
  end
end
