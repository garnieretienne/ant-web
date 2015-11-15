require 'test_helper'

class Api::V1::MailingListsControllerTest < ActionController::TestCase
  test "should post receive_message" do
    user = User.first
    list = user.mailing_lists.first
    mail = Mail.new do
      to "#{list.name}@localhost"
      from user.email_address
      subject "testing"
    end
    assert_difference("Mail::TestMailer.deliveries.length", 1) do
      @request.headers["Content-Type"] = "text/plain"
      post :receive_message, mail.to_s
      assert_response :success
    end
    sent_mail = Mail::TestMailer.deliveries.last
    assert_equal mail.from, sent_mail.from
    assert_equal mail.subject, sent_mail.subject
    assert_equal mail.to, sent_mail.reply_to
    assert_not_equal mail.to, sent_mail.to
  end
end
