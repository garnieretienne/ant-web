class ForwardListMessageService

  class ForwardListMessageServiceError < StandardError; end

  def initialize(options)
    @list_id = options.fetch(:list_id) do
      fail ForwardListMessageServiceError, "Missing list id header"
    end
    @owner = options.fetch(:owner) do
      fail ForwardListMessageServiceError, "Missing list owner address"
    end
    @subscribers = options.fetch(:subscribers) do
      fail ForwardListMessageServiceError, "Missing subscribers addresses"
    end
    @message = options.fetch(:message) do
      fail ForwardListMessageServiceError, "Missing message source"
    end
  end

  def call
    @new_message = Mail.read_from_string(@message)

    set_the_envelope_return_address
    set_the_envelope_destination_addresses
    set_the_header_sender_field
    set_the_header_list_id_field

    @new_message.deliver
  end

  private

  # RFC2822 section 3.6.2
  #
  # [...]The "Sender:" field specifies the mailbox of the agent responsible
  # for the actual transmission of the message.[...]
  #
  # REVIEW: Should we use the mailing list owner address?
  def set_the_header_sender_field
    @new_message.sender = @owner
  end

  # RFC2821 section 3.10
  #
  # [...]When a message is delivered or forwarded to each address of an
  # expanded list form, the return address in the envelope ("MAIL FROM:")
  # MUST be changed to be the address of a person or other entity who
  # administers the list.[...]
  #
  # RFC2821 section 3.10.2
  #
  # [...]The return address in the envelope is changed so that all
  # error messages generated by the final deliveries will be returned to
  # a list administrator, not to the message originator[...].
  #
  # REVIEW: Should we use the mailing list owner address?
  def set_the_envelope_return_address
    @new_message.smtp_envelope_from = @owner
  end

  # RFC2821 section 3.10.2
  #
  # [...]To expand a list, the recipient mailer replaces the pseudo-mailbox
  # address in the envelope with all of the expanded[...]
  def set_the_envelope_destination_addresses
    @new_message.smtp_envelope_to = @subscribers
  end

  # RFC2919 section 3
  #
  # [...]This header SHOULD be included on all messages distributed by the list
  # (including command responses to individual users), and on other messages
  # where the message clearly applies to this particular distinct list.[...]
  def set_the_header_list_id_field
    @new_message.header["List-Id"] = @list_id
  end
end
