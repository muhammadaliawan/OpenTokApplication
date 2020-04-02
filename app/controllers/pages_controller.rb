class PagesController < ApplicationController
  def home
    @messages = Message.all

    if Message.all.any?
      @message = Message.last

      gon.api_key = @message.apiKey
      gon.sessionID = @message.sessionID
      gon.token = @message.token
    else
      @message = Message.new
    end
  end
end
