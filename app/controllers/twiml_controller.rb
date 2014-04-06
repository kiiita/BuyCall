class TwimlController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_caller_user

  # Twilioの最初
  def start
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say "こちらは、バイ コールです。 案内 を 開始します。", language: "ja-jp"
      response.Redirect "#{Setting.app_host}/twiml/ask_product", method: 'GET'
    end.text

    render xml: xml_str
  end

  def ask_product
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '#', action: "#{Setting.app_host}/twiml/receive_product", method: 'GET' do |gather|
        gather.Say " 商品 番号 を入力 してください。 さいごに シャープ を 押してください。", language: "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  def receive_product
    xml_str = Twilio::TwiML::Response.new do |response|
      # 該当する商品がない場合
      if params_pruduct.nil?
        response.Say " 入力した 番号の 商品が みつかりません。", language: "ja-jp"
        response.Redirect "#{Setting.app_host}/twiml/ask_product", method: 'GET'
      else
        response.Redirect "#{Setting.app_host}/twiml/ask_count/#{params_pruduct.id}", method: 'GET'
        # response.Gather timeout: 30, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/ask_count/#{params_pruduct.id}", method: 'GET' do |gather|
        #   gather.Say " 入力した商品 は #{params_pruduct.name_read} ですね。", language: "ja-jp"
        #   gather.Say " よろしければ、1を。 修正したいかたは、9を押してください。", language: "ja-jp"
        # end
      end
    end.text

    render xml: xml_str
  end

  # 商品の個数を選択
  def ask_count
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '#', action: "#{Setting.app_host}/twiml/receive_product_and_count/#{params_pruduct.id}", method: 'GET' do |gather|
        gather.Say " 商品 の個数 を入力 してください。 さいごに シャープ を 押してください。", language: "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  def receive_product_and_count
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/confirm_product/#{params_pruduct.id}/#{params_count}", method: 'GET' do |gather|
        gather.Say " ご注文 は、#{params_pruduct.name_read}。個数 は #{params_count}個、ですね。", language: "ja-jp"
        gather.Say " よろしければ、1を。 修正したいかたは、9を押してください。", language: "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  def confirm_product
    xml_str = Twilio::TwiML::Response.new do |response|
      if params[:Digits].to_s == '1'

        # 注文処理
        @current_caller_user.orders.create(product: params_pruduct, count: params_count, confirm_finished: false)

        # 再訪ユーザー
        if @current_caller_user.zip
          response.Redirect "#{Setting.app_host}/twiml/ask_order", method: 'GET'
        else
          response.Redirect "#{Setting.app_host}/twiml/ask_name", method: 'GET'
        end
      else
        response.Redirect "#{Setting.app_host}/twiml/ask_product", method: 'GET'
      end
    end.text

    render xml: xml_str
  end

  def ask_name
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say " お名前を おはなし ください。 さいごに シャープ を 押してください。", language: "ja-jp"
      response.Record maxLength: '30', finishOnKey: '#', action: "#{Setting.app_host}/twiml/receive_name", :method => 'get'
    end.text

    render xml: xml_str
  end

  def receive_name
    @current_caller_user.update name_voice_url: params[:RecordingUrl]

    xml_str = Twilio::TwiML::Response.new do |response|
      response.Redirect "#{Setting.app_host}/twiml/ask_zip", method: 'GET'
    end.text

    render xml: xml_str
  end

  def ask_zip
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '', numDigits: 7, action: "#{Setting.app_host}/twiml/receive_zip", method: 'GET' do |gather|
        response.Say " 郵便番号を ハイフン無しで 入力 してください。", language: "ja-jp"
      end

    end.text

    render xml: xml_str
  end

  def receive_zip
    xml_str = Twilio::TwiML::Response.new do |response|

      # 郵便番号が不正だったら
      if params[:Digits].blank? || params[:Digits].length != 7
        response.Say " 郵便番号 に誤りがあります。", language: "ja-jp"
        response.Redirect "#{Setting.app_host}/twiml/ask_zip", method: 'GET'

      elsif ZipCode.find_address_by_code(params[:Digits]).nil?
        response.Say " 入力した 郵便番号の 住所が みつかりません。", language: "ja-jp"
        response.Redirect "#{Setting.app_host}/twiml/ask_zip", method: 'GET'

      else
        @current_caller_user.update(zip: params[:Digits], address1: ZipCode.find_address_by_code(params[:Digits]))

        response.Say " #{ZipCode.find_address_by_code(params[:Digits])} ですね。", language: "ja-jp"
        response.Gather timeout: 30, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/confirm_zip", method: 'GET' do |gather|
          gather.Say " よろしければ、1を。 修正したいかたは、9を押してください。", language: "ja-jp"
        end
      end
    end.text

    render xml: xml_str
  end

  def confirm_zip
    xml_str = Twilio::TwiML::Response.new do |response|
      if params[:Digits].to_s == '1'
        response.Redirect "#{Setting.app_host}/twiml/ask_address2", method: 'GET'
      else
        response.Redirect "#{Setting.app_host}/twiml/ask_zip", method: 'GET'
      end
    end.text

    render xml: xml_str
  end

  # 追加の住所
  def ask_address2
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say " 番地以降の 住所を おはなし ください。 さいごに シャープ を 押してください。", language: "ja-jp"
      response.Record maxLength: '60', finishOnKey: '#', action: "#{Setting.app_host}/twiml/receive_address2", :method => 'get'
    end.text

    render xml: xml_str
  end

  def receive_address2
    @current_caller_user.update address2_voice_url: params[:RecordingUrl]

    xml_str = Twilio::TwiML::Response.new do |response|
      response.Redirect "#{Setting.app_host}/twiml/ask_order", method: 'GET'
    end.text

    render xml: xml_str
  end

  # 注文確認
  def ask_order
    sum = @current_caller_user.orders.last.count * @current_caller_user.orders.last.product.price
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/confirm_order", method: 'GET' do |gather|
        gather.Say " ご注文を 確認いたします。", language: "ja-jp"
        gather.Say " ご注文 は、#{@current_caller_user.orders.last.product.name_read}　。個数 は #{@current_caller_user.orders.last.count} 個　。　お会計は、#{sum}、ですね。 ", language: "ja-jp"
        gather.Say " よろしければ、1を。 修正したいかたは、9を押してください。", language: "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  def confirm_order
    xml_str = Twilio::TwiML::Response.new do |response|
      if params[:Digits].to_s == '1'
        response.Redirect "#{Setting.app_host}/twiml/finish", method: 'GET'
      else
        response.Redirect "#{Setting.app_host}/twiml/ask_product", method: 'GET'
      end
    end.text

    render xml: xml_str
  end

  def finish
    @current_caller_user.orders.last.update(confirm_finished: true)

    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say "ご注文 ありがとうございました。 のちほど ショップから 確認の電話をすることがあります。  ", language: "ja-jp"
    end.text

    render xml: xml_str
  end

  private

  # 通話中のユーザーの設定
  def set_caller_user
    raise 'params[:Caller] is blank' if params[:Caller].blank?
    @current_caller_user ||= User.find_by(tel: params[:Caller]) || User.create(tel: params[:Caller])
  end

  def params_pruduct
    @_product ||= Product.find_by(id: (params[:product_id] || params[:Digits]))
  end

  def params_count
    params[:count] || params[:Digits]
  end

  def _log_(obj)
    puts "\n***#{obj.to_s}***\n"
  end

end
