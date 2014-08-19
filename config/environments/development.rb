# Configs for development env

App.config.define :development do

  # Set log level for App.logger
  log_level Logger::DEBUG

  Sidekiq.configure_server do |config|
    config.redis = { :namespace => 'no-comment' }
  end 

  Sidekiq.configure_client do |config|
    config.redis = { :namespace => 'no-comment' }
  end
end
