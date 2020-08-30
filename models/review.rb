class Review < ActiveRecord::Base
  belongs_to :user
  has_many :photos, as: :photoable

  validates :rating, presence: true,
    numericality: true, inclusion: { in: 0.0..10.0 }
  validates :product, presence: true
  validate :must_be_non_reviewed, if: :product_changed?

  before_save :round_rating, if: :rating_changed?

  scope :reviewed, -> (product_name) { 
    where("reviews.product ILIKE ?", "%#{product_name}%")
  }

  def self.already_reviewed?(product_name)
    reviewed(product_name).pluck(:product).any? do |pname|
      pname.parameterize == product_name.parameterize
    end
  end

  def must_be_non_reviewed
    if Review.already_reviewed?(product)
      errors.add(:product, "has already been reviewed") 
    end
  end

  private
  def round_rating
    self.rating = rating.round(1)
  end
end