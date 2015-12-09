class Api::V1::MailingListsController < APIController

  def receive_message
    message, mailing_list = parse_incoming_message

    unless message.valid?
      errors = message.errors.full_messages.join(", ")
      return render(plain: "Unvalid message: #{errors}\n", status: :bad_request)
    end

    unless message.authorized?
      return render(
        plain: "Unauthorized sender: #{message.author}\n",
        status: :unauthorized
      )
    end

    message.save

    forward_list_message_service = ForwardListMessageService.new(
      list_id: mailing_list.list_id,
      owner: mailing_list.owner.email_with_name,
      message: message.source,
      subscribers: mailing_list.subscribers.map { |s| s.email_with_name }
    )
    forward_list_message_service.call

    render(plain: "Message accepted")
  end

  private

  def parse_incoming_message
    message_string = URI.decode(request.raw_post)
    message = Message.new_from_source(message_string)
    [message, message.mailing_list]
  end
end
