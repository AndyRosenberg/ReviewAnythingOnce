class Photo < ActiveRecord::Base
  attr_accessor :uploaded
  belongs_to :photoable, :polymorphic => true
  validate :has_uploaded?, on: :create
  
  def upload(body)
    begin
      client.put_object({
        body: body, 
        bucket: ENV["AWS_BUCKET"], 
        key: key, 
      }).error

      self.uploaded = true
    rescue StandardError => e
      self.uploaded = false
    end

    self
  end

  def get_from_s3
    cached_photo = RodaCache.get("photo_#{id}")
    return cached_photo if cached_photo

    begin
      photo_body = client.get_object({
        bucket: ENV["AWS_BUCKET"], 
        key: key, 
      }).body.read

      RodaCache.set("photo_#{id}", photo_body)
      photo_body
    rescue StandardError => e
      false
    end
  end

  private
  def client
    @client ||= Aws::S3::Client.new
  end

  def has_uploaded?
    errors.add(:key, "Photo failed to upload.") unless uploaded
  end
end