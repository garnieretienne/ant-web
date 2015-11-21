require 'test_helper'

class SubscriberTest < ActiveSupport::TestCase

  test "should not save a subscriber with no name, email nor mailing list" do
    subscriber = Subscriber.new
    assert_not subscriber.save,
      "Saved a subscriber with no name nor email address"
    assert subscriber.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
    assert subscriber.errors.messages[:email].include?("can't be blank"),
      "No error message for the blank email address attribute"
    assert subscriber.errors.messages[:mailing_list].include?("can't be blank"),
      "No error message for the blank mailing list attribute"
  end

  test "should not save a subscriber with a badly formatted email address" do
    subscriber = Subscriber.new(
      name: "John Smith",
      email: "bad@formatted@address"
    )
    assert_not subscriber.save,
      "Saved a subscriber with a badly formatted email address"
    assert subscriber.errors.messages[:email].include?("is not a valid email"),
      "No error message for the badly formatted email address attribute"
  end

  test "should return the email formatted with the name" do
    subscriber = Subscriber.find_by(email: "john.smith@domain.tld")
    assert_equal "John Smith <john.smith@domain.tld>",
      subscriber.email_with_name
  end

  test "should only save new mailing subscriber email once" do
    list = MailingList.first
    subscriber = list.subscribers.first
    new_subscriber = Subscriber.new(
      name: "Mr John",
      email: subscriber.email,
      mailing_list: list
    )
    assert_not new_subscriber.save,
      "New subscriber saved with a duplicate email address"
    assert new_subscriber.errors.messages[:email]
      .include?("is already subscribed"),
        "No error message for already subscribed email address"
  end
end
