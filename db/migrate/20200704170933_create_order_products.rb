class CreateOrderProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :order_products do |t|
      t.integer :product_id
      t.integer :quantity
      t.integer :order_id

      t.timestamps
    end

    remove_column :orders, :products_id, :string
  end
end
