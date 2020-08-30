require_relative 'roda_worker'

class PhotoUploadJob < RodaWorker
  def perform(options)
    return unless has_all_keys?(options)
    review = Review.find(options["review_id"])
    Photo.send_to_s3(
      key: options["key"],
      body: options["body"],
      object: review
    )
  end

  def has_all_keys?(options)
    ["key", "body", "review_id"].all? { |opt| options.has_key?(opt) }
  end
end