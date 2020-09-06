class RodaCache
  def self.set(*args)
    source.redis { |redis| redis.set(*args) }
  end

  def self.get(key)
    source.redis { |redis| redis.get(key) }
  end

  private
  cattr_reader :source, instance_reader: false, default: Sidekiq
end
