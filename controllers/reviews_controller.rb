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
            upload_to_s3(r, review)
          end

          flash["message"] = "Review successfully created."
          r.redirect("/reviews/#{review.id}")
        else
          flash_ar_errors(review)
          view("reviews/new")
        end
      end

      r.get do
        @initial_reviews = PaginationService.paginate
        view("reviews/index")
      end
    end

    r.get "api" do
      api_only(r)

      render_json PaginationService.paginate(
        cursor: r.params["after"]
      )
    end

    r.get "new" do
      login_required(r)
      view('reviews/new')
    end

    r.on Integer do |id|
      review = Review.find_by_id(id)
      unauthorized_redirect(r, "access") unless review

      r.is do
        r.get do
          @review_json = review.to_json_with_current_status(
                           current_user_review?(review)
                         )
          view("reviews/show")
        end

        r.put do
          redirect_unless_match(r, "update", review)
          if review.update(review_params(r))
            flash["message"] = "Review has been updated!"
            r.redirect("/reviews/#{id}")
          else
            flash_ar_errors(review)
            @review_json = review.to_json
            view('reviews/edit')
          end
        end

        r.delete do
          redirect_unless_match(r, "delete", review)
          if review.destroy
            flash["message"] = "Review successfully deleted."
            r.redirect("/users/#{review.user_id}")
          else
            flash_ar_errors(review)
            @review_json = review.to_json
            view('reviews/edit')
          end
        end
      end

      r.get "edit" do
        redirect_unless_match(r, "edit", review)
        @review_json = review.to_json
        view("reviews/edit")
      end
    end
  end

  private

  def redirect_unless_match(r, action, review)
    unauthorized_redirect(r, action) unless current_user_review?(review)
  end

  def unauthorized_redirect(r, action)
    flash["message"] = "Unauthorized to #{action} this review."
    r.redirect("/")
  end

  def current_user_review?(review)
    review.user_id == session["current_user_id"].to_i
  end

  def review_params(r)
    r.params.slice("product", "rating", "body")
  end

  def photo_params_present?(r)
    r.params.slice("img_name", "img_body").all?(&:present?)
  end

  def upload_to_s3(r, review)
    PhotoUploadService.upload(
      key: r.params["img_name"],
      body: r.params["img_body"],
      object: review
    )
  end

  def floatable?(rating)
    rating.to_f.to_s == rating
  end
end
