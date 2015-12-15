# Configure the SMTP server address and port sent as headers on the NGINX
# 'http_auth' API call.
Rails.application.config.nginx_http_auth = {
  server: ENV["NGINX_HTTP_AUTH_SMTP_SERVER"] || "localhost",
  port: ENV["NGINX_HTTP_AUTH_SMTP_PORT"] || "2525"
}
