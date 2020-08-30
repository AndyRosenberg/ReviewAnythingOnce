class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :user, index: true
      t.string :product, unique: true
      t.float :rating, null: false
      t.string :body
      t.timestamps
    end
  end
end
