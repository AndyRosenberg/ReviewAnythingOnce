ENV['RACK_ENV'] = 'test'
require 'rack/test'
require 'rspec'
require 'database_cleaner/active_record'
require "#{Dir.pwd}/app.rb"

DatabaseCleaner[:active_record].strategy = :truncation

RSpec.configure do |config|
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

module RSpecMixin
  include Rack::Test::Methods
  def app() Roda end
end

RSpec.configure { |c| c.include RSpecMixin }
