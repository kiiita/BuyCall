require 'net/http'
require 'uri'

class AitalkController < ApplicationController
  protect_from_forgery with: :null_session

  def play
    send_data(Net::HTTP.get_response(URI.parse(params[:url])).body,
              filename: "voice.mp3",
              type: "audio/mpeg",
              disposition: "inline")
  end

end
