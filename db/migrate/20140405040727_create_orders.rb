class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id,          null: false
      t.integer :product_id,       null: false
      t.integer :count,            null: false, default: 1
      t.boolean :confirm_finished, null: false, default: false
      t.boolean :newly_added,      null: false, default: false
      t.boolean :shipped,          null: false, default: false
      t.boolean :money_received,   null: false, default: false

      t.timestamps
    end
  end
end
