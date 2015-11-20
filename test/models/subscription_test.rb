require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

  test "should not save a subscription with no user nor mailing list" do
    subscription = Subscription.new
    assert_not subscription.save, "Saved with no user nor mailing list"
    assert subscription.errors.messages[:user].include?("can't be blank"),
      "No error message for the user attribute"
    assert subscription.errors.messages[:mailing_list]
      .include?("can't be blank"),
        "No error message for the blank mailing list attribute"
  end

  test "should subscribe an user to a mailing list" do
    user = User.last
    list = MailingList.last
    subscription = Subscription.new(user: user, mailing_list: list)
    assert subscription.save, "Not subscribed an user to a list"
    assert list.subscribers.include?(user),
      "User is not in the list subscribers"
  end

  test "should not subscribe the same user twice to a mailing list" do
    list = MailingList.first
    user = list.subscribers.first
    subscription = Subscription.new(user: user, mailing_list: list)
    assert_not subscription.save,
      "Subscription saved with an existing subscriber"
    assert subscription.errors.messages[:user]
      .include?("is already a subscriber"),
        "No error message for already subscribed user"
  end
end
