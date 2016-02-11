require 'test_helper'

class MailboxTest < ActiveSupport::TestCase

  test "should not save a mailbox with no name nor owner" do
    mailbox = Mailbox.new
    assert_not mailbox.save, "Saved the mailbox with no name"
    assert mailbox.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
    assert mailbox.errors.messages[:owner].include?("can't be blank"),
      "No error message for the blank owner attribute"
  end

  test "should not save a mailbox with forbidden characters" do
    mailbox = Mailbox.new(name: "Foo @Bar!")
    assert_not mailbox.save,
      "Saved the mailbox with a name containing forbidden chars"
    assert mailbox.errors.messages[:name].include?(
      "must contain only lowercase alphanumeric and '-' characters"
    ), "No error messages for the invalid name attribute"
  end

  test "should not save a mailbox with a name already taken" do
    mailbox = Mailbox.first
    new_mailbox = Mailbox.new(name: mailbox.name)
    assert_not new_mailbox.save, "Saved the mailbox with an already takend name"
    assert new_mailbox.errors.messages[:name]
      .include?("has already been taken"),
        "No error messages for the duplicated name attribute"
  end

  test "should be able to find a mailbox with an address" do
    mail_domain = Rails.configuration.mail_domain
    mailbox = Mailbox.find_by_address("#{Mailbox.first.name}@#{mail_domain}")
    assert mailbox
  end

  test "should create the email and email_with_name accessors" do
    mailbox = Mailbox.first
    assert_equal "foo@localhost", mailbox.email
  end
end
