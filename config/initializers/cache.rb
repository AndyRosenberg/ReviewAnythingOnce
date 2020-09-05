class RodaCache
  def self.set(*args)
    SideKiq.redis { |redis| redis.set(*args) }
  end

  def self.get(key)
    Sidekiq.redis { |redis| redis.get(key) }
  end
end