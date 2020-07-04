class AddDeliverFare < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :delivery_fare, :float
  end
end
