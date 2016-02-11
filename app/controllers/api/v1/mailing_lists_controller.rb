class Api::V1::MailingListsController < APIController

  def receive_message
    message_string = URI.decode(request.raw_post)

    @message = Message.new(
      author: request.headers["Mail-From"],
      mailbox_address: request.headers["Rcpt-To"],
      source: message_string
    )

    if @message.save
      process_message
      return render(plain: "accepted")
    else
      return render(
        plain: "rejected",
        status: :unauthorized
      )
    end
  end

  private

  def process_message
    mailing_list = @message.mailbox.owner
    forward_list_message_service = ForwardListMessageService.new(
      list_id: mailing_list.list_id,
      owner: mailing_list.owner.email,
      message: @message.source,
      subscribers: mailing_list.subscribers.map { |s| s.email }
    )
    forward_list_message_service.call
  end
end
