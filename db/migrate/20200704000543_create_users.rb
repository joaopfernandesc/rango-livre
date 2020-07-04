class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uuid
      t.string :email
      t.string :password_hash
      t.string :CPF
      t.string :name
      t.string :phone_number
      t.double :regular_balance
      t.double :meal_allowance_balance

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
