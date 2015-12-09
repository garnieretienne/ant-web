# Access token for the API
Rails.application.config.api_token = ENV["API_TOKEN"] || SecureRandom.hex
