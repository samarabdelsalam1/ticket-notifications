REDIS = Redis.new(
  url: "redis://#{ENV.fetch('REDIS_HOST')}:#{ENV.fetch('REDIS_PORT')}/#{ENV.fetch('REDIS_DATABASE')}"
)
