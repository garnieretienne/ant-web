require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save an user with no name, email nor password" do
    user = User.new
    assert_not user.save,
      "Saved an user with no name nor email address"
    assert user.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
    assert user.errors.messages[:email].include?("can't be blank"),
      "No error message for the blank email address attribute"
      assert user.errors.messages[:password].include?("can't be blank"),
        "No error message for the blank password attribute"
  end

  test "should not save a new user with an already registered email address" do
    user = User.first
    new_user = User.new(name: "New User", email: user.email)
    assert_not new_user.save, "Saved an user with an existing email address"
    assert new_user.errors.messages[:email].include?("has already been taken"),
      "No error message for the duplicate email address attribute"
  end

  test "could have mailing lists" do
    user = User.first
    assert user.mailing_lists, "No mailing list accessors"
  end
end
