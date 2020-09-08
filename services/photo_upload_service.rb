require_relative 'service'

class PhotoUploadService < Service
  def self.upload(key:, body:, object:)
    new(key: key, body: body, object: object).call
  end

  def call
    photo = object.photos.new(key: key)

    if photo.upload(body).save
      Sidekiq.cache_set("photo_#{photo.id}", body)
    end
  end

  private
  attr_accessor :key, :body, :object
end
