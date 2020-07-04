class RenameColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :name, :restaurant
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
