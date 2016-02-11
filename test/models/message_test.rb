require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  test "should not save a message with no author, source code nor mailbox" do
    message = Message.new
    assert_not message.save,
      "Saved a message with no author nor source code nor mailbox"
    assert message.errors.messages[:author].include?("can't be blank"),
      "No error message for the blank author attribute"
    assert message.errors.messages[:source].include?("can't be blank"),
      "No error message for the blank source attribute"
    assert message.errors.messages[:mailbox].include?("can't be blank"),
      "No error message for the blank mailbox attribute"
  end

  test "should find the corresponding mailbox with a mailbox address" do
    mailbox = Mailbox.first
    message = Message.new(
      author: "anon@domain.tld",
      mailbox_address: mailbox.email,
      source:
        "Date: #{Time.now}\n" +
        "From: garnier.etienne@gmail.com\n" +
        "To: #{mailbox.email}\n\n"
    )
    assert message.valid?
    assert_equal message.mailbox, mailbox, "Wrong mailbox"
  end
end
