require_relative 'roda_worker'

class PhotoUploadJob < RodaWorker
  def perform(options)
    return unless has_all_keys?(options)
    key, body = options["key"], options["body"]
    review = Review.find(options["review_id"])

    photo = review.photos.new(key: key)
    if photo.upload(body).save
      RodaCache.set("photo_#{photo.id}", body)
    end
  end

  def has_all_keys?(options)
    ["key", "body", "review_id"].all? { |opt| options.has_key?(opt) }
  end
end