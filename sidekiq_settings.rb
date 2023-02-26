
require 'redis-namespace'
require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = {db: 1, url: ENV['REDIS_URL'] }
end
 
Sidekiq.configure_client do |config|
  config.redis = {db: 1, url: ENV['REDIS_URL']}
end