require_relative 'config/mail_config'
require_relative 'config/sidekiq_config'

class RodaWorker
  include Sidekiq::Worker

  def self.perform_async_in_prod(*args)
    ENV["RACK_ENV"] == 'production' ? perform_async(*args) : perform_now(*args)
  end

  def self.perform_now(*args)
    new.perform(*args)
  end
end
