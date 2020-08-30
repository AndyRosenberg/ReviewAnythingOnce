class Review < ActiveRecord::Base
  belongs_to :user

  validates :rating, presence: true,
    numericality: true, inclusion: { in: 0.0..10.0 }
  validates :product, presence: true
  validate :must_be_non_reviewed, if: :product_changed?

  scope :reviewed, -> (product_name) { 
    where("product ILIKE ?", "%#{product_name}%")
  }

  def self.already_reviewed?(product_name)
    reviewed(product_name).pluck(:product).any? do |pname|
      pname.parameterize == product.parameterize
    end
  end

  def must_be_non_reviewed
    if Review.already_reviewed?(product)
      errors.add(:product, "Product has been reviewed") 
    end
  end
end