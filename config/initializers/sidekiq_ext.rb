module Sidekiq
  def self.cache_set(*args)
    redis { |redis| redis.set(*args) }
  end

  def self.cache_get(key)
    redis { |redis| redis.get(key) }
  end
end
