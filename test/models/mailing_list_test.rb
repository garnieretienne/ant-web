require 'test_helper'

class MailingListTest < ActiveSupport::TestCase

  test "should not save a list with no owner, uid, nor name" do
    list = MailingList.new
    assert_not list.save, "Saved the list with missing attributes"
    assert list.errors.messages[:owner].include?("can't be blank"),
      "No error messages for the blank owner attribute"
    assert list.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
  end

  test "should create the associed mailbox when creating the mailing list" do
    list = MailingList.new(
      owner: User.first, name: "New List", mailbox_name: "new-mailbox"
    )
    assert list.save, "Not saved the mailing list"
    assert list.mailbox.persisted?, "Not saved the associed mailbox"
  end

  test "should generate a unique list id when the list is created" do
    new_mailbox = Mailbox.new(name: "test")
    list = MailingList.create(name: "Testing List", mailbox: new_mailbox)
    assert_not_nil list.uid
    assert_not_nil list.list_id
    mailbox, random, date, localhost = list.uid.split(".")
    assert_equal mailbox, list.mailbox.name,
      "Generated UID does not contain the list mailbox name"
    assert_equal 32, random.length,
      "Generated UID does not contain a random 32 hex characters string"
    assert_equal 6, date.length,
      "Generated UID does not contain the date of creation (MMYYYY)"
    assert_equal "localhost", localhost,
      "Generated UID does not end with 'localhost'"
  end
end
