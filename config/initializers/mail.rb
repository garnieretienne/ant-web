# Configure the default configuration for Mail gem.

case Rails.env
when "development"
  Mail.defaults { delivery_method :smtp }
when "test"
  Mail.defaults { delivery_method(:test) }
end

# Use the SMTP_URL environment variable if exist.
if ENV["SMTP_URL"]
  smtp_url = URI::parse(ENV["SMTP_URL"] || "smtp://localhost:25")
  smtp_user, smtp_password = smtp_url.split(":")
  Mail.defaults do
    delivery_method :smtp, {
      address: smtp_url.host,
      port: smtp_url.port,
      user_name: smtp_user,
      password: smtp_password,
      enable_starttls_auto: smtp_url.scheme == "smtps"
    }
  end
end
