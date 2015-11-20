require 'test_helper'

class SubscriberTest < ActiveSupport::TestCase

  test "should not save a subscriber with no name nor email address" do
    subscriber = Subscriber.new
    assert_not subscriber.save,
      "Saved a subscriber with no name nor email address"
    assert subscriber.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
    assert subscriber.errors.messages[:email_address]
      .include?("can't be blank"),
        "no error message for the blank email address attribute"
  end

  test "should not save a subscriber with a badly formatted email address" do
    subscriber = Subscriber.new(
      name: "John Smith",
      email_address: "bad@formatted@address"
    )
    assert_not subscriber.save,
      "Saved a subscriber with a badly formatted email address"
    assert subscriber.errors.messages[:email_address]
      .include?("is not a valid email"),
        "No error message for the badly formatted email address attribute"
  end

  test "should return the email formatted with the name" do
    subscriber = Subscriber.find_by(email_address: "john.smith@domain.tld")
    assert_equal "John Smith <john.smith@domain.tld>",
      subscriber.email_with_name
  end

  test "should only save new subscriber with unique email address" do
    subscriber = Subscriber.first
    new_subscriber = Subscriber.new(
      name: "Mr John",
      email_address: subscriber.email_address
    )
    assert_not new_subscriber.save,
      "New subscriber saved with a duplicate email address"
  end
end
