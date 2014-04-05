class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :tel, null: false
      t.string :name
      t.string :name_voice_url
      t.string :zip
      t.string :address1
      t.string :address2
      t.string :address2_voice_url

      t.timestamps
    end
  end
end
