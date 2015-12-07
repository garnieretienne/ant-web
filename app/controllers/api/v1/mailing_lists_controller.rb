class Api::V1::MailingListsController < ApplicationController
  skip_before_action :authorize, :verify_authenticity_token

  def receive_message
    message, mailing_list = parse_incoming_message

    return render(json: true, status: :bad_request) unless message.valid?
    return render(json: true, status: :unauthorized) unless message.authorized?

    message.save

    forward_list_message_service = ForwardListMessageService.new(
      list_id: mailing_list.list_id,
      owner: mailing_list.owner.email_with_name,
      message: message.source,
      subscribers: mailing_list.subscribers.map { |s| s.email_with_name }
    )

    forward_list_message_service.call
    render(json: true)
  end

  private

  def parse_incoming_message
    message_string = URI.decode(request.raw_post)
    message = Message.new_from_source(message_string)
    [message, message.mailing_list]
  end
end
