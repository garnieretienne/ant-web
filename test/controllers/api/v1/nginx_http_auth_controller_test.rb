require 'test_helper'

class Api::V1::NginxHttpAuthControllerTest < ActionController::TestCase

  test "should accept the authentication" do
    list = MailingList.first
    user = list.subscribers.first

    forge_request
    @request.headers["Auth-SMTP-From"] = "MAIL FROM: <#{user.email}>"
    @request.headers["Auth-SMTP-To"] = "RCPT TO: <#{list.name}@localhost>"

    get :auth

    assert_response :success
    assert_equal "OK", @response.headers["Auth-Status"]
    assert @response.headers.key?("Auth-Server")
    assert @response.headers.key?("Auth-Port")
  end

  test "should reject MAIL FROM field" do
    list = MailingList.first

    forge_request
    @request.headers["Auth-SMTP-From"] = "MAIL FROM: <unknown@localhost>"
    @request.headers["Auth-SMTP-To"] = "RCPT TO: <#{list.name}@localhost>"

    get :auth

    assert_response :success
    assert_not_equal "OK", @response.headers["Auth-Status"]
    assert_equal "550 5.7.2", @response.headers["Auth-Error-Code"]
  end

  test "should reject RCPT TO field" do
    list = MailingList.first

    forge_request
    @request.headers["Auth-SMTP-From"] = "MAIL FROM: <unknown@localhost>"
    @request.headers["Auth-SMTP-To"] = "RCPT TO: <unknown-list@localhost>"

    get :auth

    assert_response :success
    assert_not_equal "OK", @response.headers["Auth-Status"]
    assert_equal "550 5.1.1", @response.headers["Auth-Error-Code"]
  end

  private

  def forge_request
    @request.headers["Accept"] = "text/plain"
    @request.headers["Content-Type"] = "text/plain"
    @request.headers["Auth-Method"] = "none"
    @request.headers["Auth-User"] = nil
    @request.headers["Auth-Pass"] = nil
    @request.headers["Auth-Protocol"] = "smtp"
    @request.headers["Auth-Login-Attempt"] = 1
    @request.headers["Client-IP"] = "127.0.0.1"
    @request.headers["Client-Host"] = "localhost"
    @request.headers["Auth-SMTP-Helo"] = "localhost"
  end
end
