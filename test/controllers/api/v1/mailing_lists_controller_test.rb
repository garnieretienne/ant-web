require 'test_helper'

class Api::V1::MailingListsControllerTest < ActionController::TestCase

  test "should post receive_message" do
    list = MailingList.first
    subscriber = list.subscribers.first
    mail = Mail.new do
      to "#{list.name}@localhost"
      from subscriber.email
      subject "testing"
    end

    assert_difference("Mail::TestMailer.deliveries.length", 1) do
      @request.headers["Content-Type"] = "text/plain"
      post :receive_message, mail.to_s
      assert_response :success
    end
    sent_mail = Mail::TestMailer.deliveries.last

    assert_equal mail.from, sent_mail.from,
      "The mail From header field has changed"

    assert_equal mail.to, sent_mail.to,
      "The mail To header field has changed"

    assert_equal mail.subject, sent_mail.subject,
      "The mail Subject header field has changed"

    assert_equal list.subscribers.map{ |s| s.email } - [subscriber.email],
      sent_mail.smtp_envelope_to,
      "The mail TO envelope field has not been updated with the list " +
      "subscribers list"

    assert_equal list.owner.email, sent_mail.smtp_envelope_from,
      "The mail FROM envelope field has not been updated with the list " +
      "owner address"

    assert_equal list.owner.email, sent_mail.sender,
      "The mail Sender header field has not been updated with the list " +
      "owner address"

    assert_equal list.list_id, sent_mail["List-Id"].value,
      "The mail List-Id field is not set with the correct list id"
  end

  test "should not duplicate an email" do
    list = MailingList.first
    subscriber_1 = list.subscribers.first
    subscriber_2 = list.subscribers.last

    mail = Mail.new do
      to subscriber_2.email
      cc "#{list.name}@localhost"
      from subscriber_1.email
      subject "testing"
    end

    assert_difference("Mail::TestMailer.deliveries.length", 1) do
      @request.headers["Content-Type"] = "text/plain"
      post :receive_message, mail.to_s
      assert_response :success
    end
    sent_mail = Mail::TestMailer.deliveries.last

    assert_not sent_mail.smtp_envelope_to.include?(subscriber_2.email),
      "Message delivered to an address already in the recipients list"
    assert_not sent_mail.smtp_envelope_to.include?(subscriber_1.email),
      "Message delivered to the message sender"
  end
end
