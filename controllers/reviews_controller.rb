class ReviewsController < Roda
  route do |r|
    r.is do
      r.post do
        # create
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
    # r.params.slice("email", "name", "password", "time_zone")
  end
end
