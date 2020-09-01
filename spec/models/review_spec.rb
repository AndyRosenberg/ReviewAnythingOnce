require 'spec_helper'

describe Review do
  before do
    Review.create(rating: 5.0, product: "some product")
  end

  describe "::already_reviewed?" do
    it "returns false if it's different" do
      expect(Review.already_reviewed?("some other product")).to be false
    end

    it "returns true if it's the same" do
      expect(Review.already_reviewed?("some product")).to be true
    end

    it "returns true if it's similar via punctuaton" do
      expect(Review.already_reviewed?("some product!")).to be true
    end

    it "returns true if it's similar via punctuaton" do
      expect(Review.already_reviewed?("  some product ")).to be true
    end
  end

  describe "#round_rating" do
    let(:review) { Review.last }

    it "changes when the rating changes" do
      expect(review).to receive(:round_rating)
      review.update(rating: 6.2)
    end

    it "changes when the rating changes" do
      expect(review).not_to receive(:round_rating)
      review.update(product: "other")
    end
  end
end