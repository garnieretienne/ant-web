require 'test_helper'

class MailingListsControllerTest < ActionController::TestCase

  def setup
    session[:user_id] = User.first.id
  end

  test "should get access if identified" do
    get :index
    assert_response :success
  end

  test "should create a mailing list" do
    post :create, mailing_list: {name: "Haz Nuts", mailbox_name: "haz-nuts"}
    assert_redirected_to mailing_lists_path
    assert_equal "Mailing list created", flash[:notice]
  end
end
