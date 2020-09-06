require_relative 'roda_worker'

class PhotoUploadJob < RodaWorker
  def perform(options)
    return unless has_all_keys?(options)
    object = options["object_type"].constantize.find(options["object_id"])
    options = options.slice("key", "body").merge({"object" => object})
    PhotoUploadService.upload(options.symbolize_keys)
  end

  def has_all_keys?(options)
    ["key", "body", "object_id", "object_type"].all? { |opt| options.has_key?(opt) }
  end
end
