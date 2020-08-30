class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :key
      t.timestamps
    end

    add_reference :photos, :photoable, polymorphic: true, index: true
  end
end
