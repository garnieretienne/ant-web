require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

  test "should not save a subscription with no subscriber nor mailing list" do
    subscription = Subscription.new
    assert_not subscription.save, "Saved with no subscriber nor mailing list"
    assert subscription.errors.messages[:subscriber].include?("can't be blank"),
      "No error message for the subscriber attribute"
    assert subscription.errors.messages[:mailing_list]
      .include?("can't be blank"),
        "No error message for the blank mailing list attribute"
  end

  test "should subscribe an existing subscriber to a mailing list" do
    subscriber = Subscriber.last
    list = MailingList.last
    subscription = Subscription.new(subscriber: subscriber, mailing_list: list)
    assert subscription.save, "Not subscribed a subscriber to a list"
    assert list.subscribers.include?(subscriber),
      "Subscriber is not present in the list subscribers"
  end

  test "should not subscribe the same subscriber twice to a mailing list" do
    list = MailingList.first
    subscriber = list.subscribers.first
    subscription = Subscription.new(subscriber: subscriber, mailing_list: list)
    assert_not subscription.save,
      "Subscription saved with an existing subscriber"
    assert subscription.errors.messages[:subscriber]
      .include?("is already a subscriber"),
        "No error message for already subscribed subscriber"
  end
end
