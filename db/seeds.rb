# coding: utf-8
u1 = User.create(:tel => '+818046771897' ,  :name => 'ヤマダタロウ', :zip => '272-0142', :address1 => '南行徳', :address2 => '２−３−１１')
p1 = Product.create(:id => 101, :name => 'テスト商品', :name_read => 'てすとしょうひん', :price => 1000, :count => 100)

Order.create(:user_id => u1.id, :product_id => p1.id)
