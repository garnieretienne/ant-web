require 'test_helper'

class MailingListTest < ActiveSupport::TestCase

  test "should not save a list with no owner, title nor name" do
    list = MailingList.new
    assert_not list.save, "Saved the list with no title nor name"
    assert list.errors.messages[:owner].include?("can't be blank"),
      "No error messages for the blank owner attribute"
    assert list.errors.messages[:name].include?("can't be blank"),
      "No error message for the blank name attribute"
    assert list.errors.messages[:title].include?("can't be blank"),
      "No error messages for the blank title attribute"
  end

  test "should not save a list with an already taken name" do
    list = MailingList.new(name: "foo", title: "Foo Bar")
    assert_not list.save, "Saved the list with a name already taken"
    assert list.errors.messages[:name].include?("has already been taken"),
      "No error messages for the duplicated title attribute"
  end

  test "should only save list with low chars name and no space" do
    list = MailingList.new(name: "Foo @Bar!", title: "Foo Bar")
    assert_not list.save,
      "Saved the list with a name containing forbidden chars"
    assert list.errors.messages[:name].include?('is invalid'),
      "No error messages for the invalid name attribute"
  end
end
