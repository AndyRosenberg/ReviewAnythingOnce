class PhotosController < Roda
  route do |r|
    r.on Integer do |id|
      r.is do
        r.get do
          photo = Photo.find_by_id(id)
          return render_unprocessable unless photo
          photo_body = photo.get_from_s3
          return render_unprocessable unless photo_body
          render_json({ "photo" => photo_body }.to_json)
        end
      end
    end
  end
end
