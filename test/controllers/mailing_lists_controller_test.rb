require 'test_helper'

class MailingListsControllerTest < ActionController::TestCase

  test "should get redirected if not authenticated" do
    get(:index)
    assert_response(:redirect)
  end

  test "should get access if identified" do
    user = User.first
    get(:index, {}, {user_id: user.id})
    assert_response :success
  end
end
