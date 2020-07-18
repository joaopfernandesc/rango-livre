class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :uuid
      t.float :price
      t.string :name
      t.string :products_id
      t.string :user_uuid

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
