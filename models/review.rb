class Review < ActiveRecord::Base
  include PgSearch::Model
  belongs_to :user
  has_many :photos, as: :photoable, dependent: :destroy
  pg_search_scope :similar_to,
                  against: :product,
                  using: :trigram

  validates :rating, presence: true, inclusion: { in: 0.0..10.0 }
  validates :product, presence: true
  validate :must_be_non_reviewed, if: :product_changed?

  before_save :round_rating, if: :rating_changed?

  def self.already_reviewed?(product_name)
    product_prz = product_name.parameterize
    similar_to(product_name).pluck(:product).any? do |pname|
      pname.parameterize == product_prz
    end
  end

  def must_be_non_reviewed
    if Review.already_reviewed?(product)
      errors.add(:product, "has already been reviewed") 
    end
  end

  def to_json_with_photo_ids
    as_json_with_photo_ids.to_json
  end

  def to_json_with_current_status(current = false)
    return to_json_with_photo_ids unless current
    as_json_with_photo_ids.merge("current" => true).to_json
  end

  private
  def round_rating
    self.rating = rating.round(1)
  end

  def as_json_with_photo_ids
    as_json.merge("photo_ids" => photos.pluck(:id))
  end
end
