# Configure the defautt configuration for Mail gem.

case Rails.env
when "development"
  Mail.defaults { delivery_method(:smtp, enable_starttls_auto: false) }
when "test"
  Mail.defaults { delivery_method(:test) }
end
