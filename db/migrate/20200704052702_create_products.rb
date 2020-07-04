class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :uuid
      t.string :image_url
      t.string :name
      t.string :category
      t.float :actual_price
      t.float :regular_price
      t.float :discount
      t.string :description
      t.float :average_rating, :default => nil
      t.integer :total_ratings, :default => 0
      t.integer :min_estimative
      t.integer :max_estimative
      t.string :city

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
