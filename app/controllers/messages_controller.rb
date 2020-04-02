class MessagesController < ApplicationController
  require "opentok"

  before_action :config_opentok

  def create
    if Message.all.count == 0
      @message = Message.new(message_params)
      @message.user = current_user
      @message.apiKey = @api_key

      @session = @opentok.create_session
      @message.sessionID = @session.session_id

      @token = @opentok.generate_token @message.sessionID
      @message.token = @token
      
      @message.save
    end

    gon.sessionID = @message.sessionID
    gon.token = @message.token
  end

  def destroy
    @message = Message.last

    @message.destroy
    redirect_to root_path
  end

  private

  def config_opentok
    if @opentok.nil?
      @api_key = 46626302
      api_secret = "595ed8778825da166d76d84053a2867f239216df"
      @opentok = OpenTok::OpenTok.new @api_key, api_secret
      gon.apiKey = @api_key
    end
  end

  def message_params
    params.require(:message).permit(:name)
  end
end
