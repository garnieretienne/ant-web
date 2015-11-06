class Api::V1::MailingListsController < ApplicationController
  protect_from_forgery(with: :null_session)

  def receive_message
    logger.info("Receiving incoming message from MTA...")

    parse_message
    parse_mailing_list_name

    list = MailingList.find_by(name: @list_name)

    unless list || list.is_allowed_to_post?(@message.from)
      return render(json: true, status: :unauthorized)
    end

    @message.reply_to, @message.to = @message.to, list.subscribers

    unless @message.deliver
      logger.warn("Received message not delivered.")
      return render(json: true, status: :internal_server_error)
    end

    logger.info("Received message delivered.")
    render(json: true)
  end

  private

  def parse_message
    message_string = URI.decode(request.raw_post)
    @message = Mail.read_from_string(message_string)
  end

  def parse_mailing_list_name
    to = @message.to_addrs && @message.to_addrs.first
    @list_name = to && to.split('@').first
  end
end
