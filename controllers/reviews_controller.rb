class ReviewsController < Roda
  route do |r|
    r.is do
      r.post do
        login_required(r)

        review_attrs = review_params(r).merge(
          "user_id" => session["current_user_id"]
        )

        unless floatable?(review_attrs["rating"])
          flash.now["message"] = "Bad rating value."
          view("reviews/new")
        end

        review = Review.create(review_attrs)

        if review.persisted?
          if photo_params_present?(r)
            PhotoUploadJob.perform_now(
              "key" => r.params["img_name"],
              "body" => r.params["img_body"],
              "review_id" => review.id
            )
          end

          flash["message"] = "Review successfully created."
          r.redirect("/reviews/#{review.id}")
        else
          flash_ar_errors(review)
          view("reviews/new")
        end
      end
    end

    r.get "new" do
      login_required(r)
      view('reviews/new')
    end

    r.on Integer do |id|
      r.is do
        r.get do
          show_review = Review.find_by_id(id)
          unless show_review
            flash["message"] = "Unauthorized to view this review."
            r.redirect("/")
          end
          @review_json = show_review.to_json_with_photo_ids
          view("reviews/show")
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
