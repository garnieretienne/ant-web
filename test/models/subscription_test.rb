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
    assert user.mailing_lists.include?(list),
      "Subscribed list is not present in the user subscriptions"
  end
end
