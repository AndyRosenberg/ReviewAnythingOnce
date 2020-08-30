class ReviewsController < Roda
  route do |r|
    r.is do
      r.post do
        review_attrs = review_params(r)
        unless floatable?(review_attrs["rating"])
          flash.now["message"] = "Bad rating value."
          view("reviews/new")
        end

        review_attrs.merge!(
          "user_id" => session["current_user_id"],
          "rating" => review_attrs["rating"].to_f
        )

        review = Review.create(review_attrs)

        if !review.new_record?
          PhotoUploadJob.perform_async_in_prod(
            "key" => r.params["img_name"],
            "body" => r.params["img_body"],
            "review_id" => review.id
          ) if photo_params_present?(r)

          flash["message"] = "Review successfully created."
          r.redirect("/")
        else
          flash_ar_errors(review)
          view("reviews/new")
        end
      end
    end

    r.get "new" do
      view('reviews/new')
    end

    r.on Integer do |id|
      r.is do
        r.get do
          # show
        end

        r.put do
          # update
        end

        r.delete do
          # destroy
        end
      end

      r.get "edit" do
        # edit
      end
    end
  end

  private

  def review_params(r)
    r.params.slice("product", "rating", "body")
  end

  def photo_params_present?(r)
    r.params.slice("img_name", "img_body").all?(&:present?)
  end

  def floatable?(rating)
    rating.to_f.to_s == rating
  end
end
