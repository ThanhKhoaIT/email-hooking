# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://0.0.0.0:6379/10' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://0.0.0.0:6379/10' }
end
