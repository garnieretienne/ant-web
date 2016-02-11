require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest

  test "force to login to browse the site" do
    user = User.first

    get "/"
    assert_redirected_to login_path

    post "/sessions", email: user.email, password: "password"
    assert_redirected_to root_path
  end
end
