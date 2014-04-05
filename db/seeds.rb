# coding: utf-8
u1 = User.create(:tel => '08046771897' , :name => 'たお商店', :zip => '272-0142', :address1 => 'gushiken@zigexn.co.jp', :address2 => '' )

Order.create(:user_id => u1.id, :product_id => '2011-11-14')
Product.create(:name => 'テスト商品', :name_read => 'てすとしょうひん', :price => 1000, :count => 100)