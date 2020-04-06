class MessagesController < ApplicationController
  require "opentok"

  before_action :config_opentok

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.apiKey = @apiKey

    @session = @opentok.create_session
    @message.sessionID = @session.session_id

    @token = @opentok.generate_token @message.sessionID
    @message.token = @token

    gon.apiKey = @message.apiKey
    gon.sessionID = @message.sessionID
    gon.token = @message.token
    
    @message.save
  end

  def destroy
    @message = Message.last

    @message.destroy
    redirect_to root_path
  end

  private

  def config_opentok
    tries = 3
    begin
      @apiKey = 46626302
      @apiSecret = "595ed8778825da166d76d84053a2867f239216df"
      @opentok = OpenTok::OpenTok.new @apiKey, @apiSecret
      logger.debug "opentok connected."
    rescue Errno::ETIMEDOUT => e
      log.error e 
      tries -= 1
      if tries > 0
        logger.debug "retrying opentok.new..."
      retry 
      else
        logger.debug "opentok.new timed out..."
        puts "ERROR: #{e.message}" 
      end
    end
  end

  def message_params
    params.require(:message).permit(:name)
  end
end
