Rails.application.configure do
  config.lograge.enabled = true

  # Add timestamp to logs
  config.lograge.custom_options = ->(event) { {time: event.time} }
end
