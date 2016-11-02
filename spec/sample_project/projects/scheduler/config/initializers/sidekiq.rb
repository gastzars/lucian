Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Scheduler::RedisConfig["host"]}:#{Scheduler::RedisConfig["port"]}/#{Scheduler::RedisConfig["db"]}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{Scheduler::RedisConfig["host"]}:#{Scheduler::RedisConfig["port"]}/#{Scheduler::RedisConfig["db"]}" }
end
