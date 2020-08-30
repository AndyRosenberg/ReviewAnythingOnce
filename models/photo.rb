class Photo < ActiveRecord::Base
  attr_accessor :uploaded
  belongs_to :photoable, :polymorphic => true
  validate :has_uploaded?, on: :create
  
  def self.send_to_s3(key:, body:, object:)
    object.photos.new(key: key).upload(body).save
  end
  
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

  private
  def client
    @client ||= Aws::S3::Client.new
  end

  def has_uploaded?
    errors.add(:key, "Photo failed to upload.") unless uploaded
  end
end