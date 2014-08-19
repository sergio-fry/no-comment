# Configs for production env

App.config.define :production do

  # Set log level for App.logger
  log_level Logger::WARN


  Sidekiq.configure_server do |config|
    config.redis = { :url => ENV['REDIS_PROVIDER'], :namespace => 'no-comment' }
  end 

  Sidekiq.configure_client do |config|
    config.redis = { :url => ENV['REDIS_PROVIDER'], :namespace => 'no-comment' }
  end
end
