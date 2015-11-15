class ForwardListMessageService

  class ForwardListMessageServiceError < StandardError; end

  def initialize(options)
    @subscribers = options.fetch(:subscribers) do
      fail ForwardListMessageServiceError, "Missing subscribers addresses"
    end
    @message = options.fetch(:message) do
      fail ForwardListMessageServiceError, "Missing message source"
    end
  end

  # TODO: send to each subscribers individually and implement report
  def call
    new_message = Mail.read_from_string(@message)
    new_message.reply_to, new_message.to = new_message.to, @subscribers

    new_message.deliver
  end
end
