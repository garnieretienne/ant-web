# Define the main domain used for the mailing lists and aliases address.
Rails.application.config.mail_domain = ENV["MAIL_DOMAIN"] || "localhost"
