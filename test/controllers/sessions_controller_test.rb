require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "should get the login page without authentication" do
    get :new
    assert_response :success
  end
end
