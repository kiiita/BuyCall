# coding: utf-8
u1 = User.create(tel: '+818046775597' ,
                 name: 'ヤマダタロウ',
                 name_voice_url: 'http://api.twilio.com/2010-04-01/Accounts/ACb79305fdebd8ec100e0c9ef23170262a/Recordings/REa8d3c4411fb509cabe631e04ba87bb1b',
                 zip: '2720142',
                 address1: '南行徳',
                 address2: '２−３−１１',
                 address2_voice_url: 'http://api.twilio.com/2010-04-01/Accounts/ACb79305fdebd8ec100e0c9ef23170262a/Recordings/RE77e19f41604480c565333af01ec1ef19')
u2 = User.create(tel: '+818043341552' ,
                 name: nil,
                 name_voice_url: 'http://api.twilio.com/2010-04-01/Accounts/ACb79305fdebd8ec100e0c9ef23170262a/Recordings/REa8d3c4411fb509cabe631e04ba87bb1b',
                 zip: '2720142',
                 address1: '南行徳',
                 address2: nil,
                 address2_voice_url: 'http://api.twilio.com/2010-04-01/Accounts/ACb79305fdebd8ec100e0c9ef23170262a/Recordings/RE77e19f41604480c565333af01ec1ef19')

p1 = Product.create(id: 101, name: '安眠枕', name_read: 'あんみん まくら', price: 1000, count: 100)
p2 = Product.create(id: 102, name: 'すごいボールペン', name_read: 'すごい ボールペン', price: 2980, count: 30)


Order.create(user: u1, product: p1, confirm_finished: true, newly_added: true, shipped: false, money_received: true)
Order.create(user: u1, product: p1, confirm_finished: false, newly_added: false, shipped: false, money_received: false)
Order.create(user: u1, product: p2, confirm_finished: true, newly_added: true, shipped: false, money_received: false)
Order.create(user: u2, product: p2, confirm_finished: true, newly_added: true, shipped: true, money_received: true)
Order.create(user: u2, product: p1, confirm_finished: true, newly_added: false, shipped: false, money_received: true)
