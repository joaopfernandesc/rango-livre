class CreateUserAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_addresses do |t|
      t.string :street
      t.string :number
      t.string :description
      t.string :CEP
      t.string :city
      t.string :uf

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
