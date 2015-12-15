# Implement the NGINX "auth_http" protocol
#
# See: http://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#protocol
# See: `config/initializers/nginx_http_auth.rb`
class Api::V1::NginxHttpAuthController < APIController

  def auth
    header_validated =
      request.headers["Auth-SMTP-From"] =~ /MAIL FROM: <.*>/ &&
      request.headers["Auth-SMTP-To"] =~ /RCPT TO: <.*@.*>/

    unless header_validated
      return render plain: "", status: :unprocessable_entity
    end

    from_addr = request.headers["Auth-SMTP-From"][/MAIL FROM: <(.*)>/, 1]
    to_name = request.headers["Auth-SMTP-To"][/RCPT TO: <(.*)@.*>/, 1]

    return auth_failed_to unless list = MailingList.find_by(name: to_name)
    return auth_failed_from unless list.authorized_to_post?(from_addr)

    return auth_succeed
  end

  private

  def auth_succeed
    response.headers["Auth-Status"] = "OK"
    response.headers["Auth-Server"] =
      Rails.configuration.nginx_http_auth[:server]
    response.headers["Auth-Port"] =
      Rails.configuration.nginx_http_auth[:port]
    render plain: ""
  end

  def auth_failed_from
    response.headers["Auth-Status"] = "Mailing list expansion prohibited"
    response.headers["Auth-Error-Code"] = "550 5.7.2"
    render plain: ""
  end

  def auth_failed_to
    response.headers["Auth-Status"] = "Bad destination mailbox address"
    response.headers["Auth-Error-Code"] = "550 5.1.1"
    render plain: ""
  end
end
