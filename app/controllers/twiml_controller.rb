class TwimlController < ApplicationController

  protect_from_forgery with: :null_session

  # Twilioの最初
  def start
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say " ポチ ベル をご利用いただき ありがとう ございます。 ", :language => "ja-jp"
      response.Redirect "#{Setting.app_host}/twiml/ask_region?user_id=#{twilio_current_user.id}", method: 'POST'
    end.text

    render xml: xml_str
  end

  # エリアを聞く
  def ask_region
    # TwiMLを作成
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Gather timeout: 40, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/question?q_num=1&user_id=#{twilio_current_user.id}" do |gather|
        gather.Say "旅行 の 行き先 を 決めてください", :language => "ja-jp"

        Region.all.each do |region|
          gather.Say "。 #{region.name} がいいかたは、 #{region.id} を", :language => "ja-jp"
        end

        gather.Say "押してください", :language => "ja-jp"
      end
    end.text

    render xml: xml_str
  end

  # Twilioの質問
  def question
    # 質問番号 0から始まる
    q_num = params[:q_num].to_i

    # 直前の回答
    last_answer = params[:Digits].presence.try(:to_i)

    # 直前の回答を保存
    # 直前がエリア絞り込みの場合
    if q_num == 1
      twilio_current_user.update_attributes({
        reg_id: last_answer
      })
    else
      last_answered_conditon_id = twilio_current_user.last_id_to_conditon_id(last_answer)
      twilio_current_user.update_attributes({
        "cond_#{q_num - 1}".to_sym => twilio_current_user.last_id_to_conditon_id(last_answer), # :cond_2 => 1
      })
    end

    current_4conditions = twilio_current_user.get_next_conditions!

    api_request = ApiRequest.generate(twilio_current_user.generate_condition_for_request)

    puts "*** api_request.total_count: #{api_request.total_count}"

    # 質問が終了する場合
    #   1. 次の絞り込みで件数が0になる
    #   2. 質問が終わる(TODO)
    if twilio_current_user.finish_question?
      xml_str = Twilio::TwiML::Response.new do |response|
        response.Redirect "#{Setting.app_host}/twiml/finish?user_id=#{twilio_current_user.id}", method: 'POST'
      end.text

      render xml: xml_str

    # 質問を継続する場合
    else
      # TwiMLを作成
      xml_str = Twilio::TwiML::Response.new do |response|
        response.Gather timeout: 40, finishOnKey: '', numDigits: 1, action: "#{Setting.app_host}/twiml/question?q_num=#{q_num + 1}&user_id=#{twilio_current_user.id}" do |gather|

          # 直前の回答がある場合はそれを繰り返す
          if last_answer && q_num > 1
            gather.Say "#{Condition.find(last_answered_conditon_id).name} ですね。", :language => "ja-jp"
          end

          # 現在の件数
          # gather.Say "現在の検索条件で、 #{api_request.total_count.to_s}件が、ヒットします。", :language => "ja-jp"

          gather.Say "次の 4つのなかから、こだわりたい条件を一つ、選んでください。", :language => "ja-jp"

          current_4conditions.each.with_index(1) do |condition, i|
            gather.Say "#{condition.name}、がいいかたは、#{i} を", :language => "ja-jp"
          end
          gather.Say "押してください", :language => "ja-jp"
        end
      end.text

      render xml: xml_str
    end
  end

  # Twilioの最後
  def finish
    xml_str = Twilio::TwiML::Response.new do |response|
      response.Say "あなたに ぴったりの 宿泊場所が見つかりました。 。 。", :language => "ja-jp"
      response.Say "自動的に電話を終了して、ブラウザに戻ります。。", :language => "ja-jp"
    end.text

    render xml: xml_str
  end
end
