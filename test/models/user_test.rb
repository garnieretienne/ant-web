require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save a user with no name nor email address" do
    user = User.new
    assert_not user.save, "Saved a user with no name nor email address"
    assert user.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
    assert user.errors.messages[:email_address].include?("can't be blank"),
      "no error message for the blank email address attribute"
  end

  test "should not save a user with a badly formatted email address" do
    user = User.new(name: "John Smith", email_address: "bad@formatted@address")
    assert_not user.save, "Saved a user with a badly formatted email address"
    assert user.errors.messages[:email_address]
      .include?("is not a valid email"),
        "No error message for the badly formatted email address attribute"
  end

  test "should return the email formatted with the name" do
    user = User.find_by(email_address: "john.smith@domain.tld")
    assert_equal "John Smith <john.smith@domain.tld>", user.email_with_name
  end

  test "should only save new user with unique email address" do
    user = User.first
    new_user = User.new(name: "Mr John", email_address: user.email_address)
    assert_not new_user.save, "New user saved with a duplicate email address"
  end
end
