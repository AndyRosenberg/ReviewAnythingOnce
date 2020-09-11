class PhotosController < Roda
  route do |r|
    r.on "by_type", String, Integer do |type, id|
      self.photo = Photo.find_by(photoable_type: type.capitalize, photoable_id: id)
      render_photo_body?
    end

    r.on Integer do |id|
      r.is do
        r.get do
          self.photo = Photo.find_by_id(id)
          render_photo_body?
        end
      end
    end
  end

  private
  attr_accessor :photo

  def render_photo_body?
    return render_unprocessable unless photo
    photo_body = photo.get_from_s3
    return render_unprocessable unless photo_body
    render_json({ "photo" => photo_body }.to_json)
  end
end
