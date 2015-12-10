# Configure the default configuration for Mail gem.

case Rails.env
when "development"
  Mail.defaults { delivery_method :smtp }
when "test"
  Mail.defaults { delivery_method :test }
end

# Use the SMTP_URL environment variable if exist.
if ENV["SMTP_URL"]
  smtp_url = URI::parse(ENV["SMTP_URL"])

  smtp_settings = {
    address: smtp_url.host,
    port: smtp_url.port,
    user_name: smtp_url.user,
    password: smtp_url.password,
    enable_starttls_auto: smtp_url.scheme == "smtps"
  }

  if ENV["SMTP_VERIFY_SSL"] == "false"
    smtp_settings[:openssl_verify_mode] = "none"
  end

  Mail.defaults { delivery_method :smtp, smtp_settings }
end
