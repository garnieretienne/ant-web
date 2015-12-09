# Access token for the API
Rails.application.config.api_token = ENV["API_TOKEN"] || SecureRandom.hex

# Do not use for the test environment
Rails.application.config.api_token = nil if Rails.env.test?
