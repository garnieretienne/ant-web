require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase

  test "should get redirected if not authenticated" do
    mailing_list = MailingList.first
    get(:index, mailing_list_id: mailing_list.id)
    assert_response(:redirect)
  end

  test "should get access if identified" do
    mailing_list = MailingList.first
    user = mailing_list.owner
    session
    get(:index, {mailing_list_id: mailing_list.id}, {user_id: user.id})
    assert_response(:success)
  end
end
