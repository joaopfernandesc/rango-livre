# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uuid
      t.string :email
      t.string :password_hash
      t.string :CPF
      t.string :name
      t.string :phone_number
      t.float :regular_balance
      t.float :meal_allowance_balance

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
