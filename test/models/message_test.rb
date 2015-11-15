require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  test "should not save a message with no author, source code nor list" do
    message = Message.new
    assert_not message.save,
      "Saved a message with no author nor source code nor list"
    assert message.errors.messages[:author].include?("can't be blank"),
      "No error message for the blank author attribute"
    assert message.errors.messages[:source].include?("can't be blank"),
      "No error message for the blank source attribute"
    assert message.errors.messages[:mailing_list].include?("can't be blank"),
      "No error message for the blank list attribute"
  end

  test "should create new message correctly parsing an email source" do
    source = <<-EOF.strip_heredoc
      From: Foo Bar <foo@bar.tld>
      To: Hello World <hello@world.tld>
      Subject: Testing
      Mime-Version: 1.0
      Content-Type: text/plain;
      charset=UTF-8
      Content-Transfer-Encoding: 8bit

      Hello!
    EOF
    message = Message.new_from_source(source)
    assert message.valid?, "Message parsed from correct source is not valid"
  end
end
