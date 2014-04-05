require 'webpay'

namespace :credits do
  # :environment は モデルにアクセスするのに必須
  desc 'webpayでクレジットカードに課金を行う'
  task :generate => :environment do
    # 処理を記述

    WebPay.api_key = "test_secret_0Fkb3d0N29mug3R7HL1Va4Eu"
    WebPay::Charge.create(
        :amount=>400,
        :currency=>"jpy",
        :card=>
            {:number=>"4242-4242-4242-4242",
             :exp_month=>"11",
             :exp_year=>"2014",
             :cvc=>"123",
             :name=>"KEI KUBO"}
    )
  end

end
