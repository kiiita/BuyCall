class TwimlController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_caller_user

  # Twilioの最初
  def start
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say " バイ コール をご利用いただき ありがとう ございます。 ", :language => "ja-jp"
      response.Redirect "#{Setting.app_host}/twiml/ask_shop", method: 'GET'
    end.text

    render xml: xml_str
  end

  # エリアを聞く
  def ask_shop
    # TwiMLを作成
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '*', action: "#{Setting.app_host}/twiml/ask_product", method: 'GET' do |gather|
        gather.Say " ショップ アイディ を入力 してください。 入力が 完了したら アスタリスク を 押してください", :language => "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  def ask_product
    # TwiMLを作成
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '*', action: "#{Setting.app_host}/twiml/confirm_product", method: 'GET' do |gather|
        gather.Say " 商品 アイディ を入力 してください。 入力が 完了したら アスタリスク を 押してください", :language => "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  def confirm_product
    # TwiMLを作成
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 30, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/finish", method: 'GET' do |gather|
        gather.Say " 入力した商品 アイディは #{params[:Digits]} ですね。", :language => "ja-jp"
        gather.Say " よろしければ、1を。 修正したいかたは、9を押してください。", :language => "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  # def ask_shop
  #   # TwiMLを作成
  #   xml_str = Twilio::TwiML::Response.new do |response|
  #     response.Gather timeout: 40, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/question?q_num=1&user_id=#{twilio_current_user.id}" do |gather|
  #       gather.Say "旅行 の 行き先 を 決めてください", :language => "ja-jp"

  #       Region.all.each do |region|
  #         gather.Say "。 #{region.name} がいいかたは、 #{region.id} を", :language => "ja-jp"
  #       end

  #       gather.Say "押してください", :language => "ja-jp"
  #     end
  #   end.text

  #   render xml: xml_str
  # end

  # Twilioの最後
  def finish
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say "ご注文ありがとうございました。　　　　のちほど 確認の電話をすることがあります。 ", :language => "ja-jp"
    end.text

    render xml: xml_str
  end

  private

  # 通話中のユーザーの設定
  def set_caller_user
    raise 'params[:Caller] is blank' if params[:Caller].blank?
    @current_caller_user ||= User.find_by(tel: params[:Caller]) || User.create(tel: params[:Caller])
  end

end
