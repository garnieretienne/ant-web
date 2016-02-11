require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase

  def setup
    @mailing_list = MailingList.first
    session[:user_id] = @mailing_list.owner.id
  end

  test "should get access if identified" do
    get :index, mailing_list_id: @mailing_list.id
    assert_response :success
  end

  test "should add a subscriber to the mailing list" do
    post :create,
      mailing_list_id: @mailing_list.id,
      subscriber: {name: "Kitty Smith", email: "kitty.smith@domain.tld"}
    assert_redirected_to mailing_list_subscribers_path
    assert_equal "Subscriber added", flash[:notice]
  end

  test "should remove a subscriber from the mailing list" do
    subscriber = @mailing_list.subscribers.first
    delete :destroy, mailing_list_id: @mailing_list.id, id: subscriber.id
    assert_redirected_to mailing_list_subscribers_path
    assert_equal "Email removed from subscribers", flash[:notice]
  end
end
