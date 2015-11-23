require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase

  test "should get index" do
    mailing_list = MailingList.first
    get :index, mailing_list_id: mailing_list.id
    assert_response :success
  end
end
