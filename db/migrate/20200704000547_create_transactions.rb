class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :uuid
      t.integer :order_id
      t.float :amount
      t.integer :transaction_type
      t.integer :account_type
      t.string :from_CPF
      t.string :to_CPF
      t.boolean :scheduled
      t.integer :timestamp

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
