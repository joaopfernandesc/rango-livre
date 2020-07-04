# frozen_string_literal: true

class RenameUserColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :password_hash, :password_digest
    add_column :user_addresses, :nickname, :string
    add_column :user_addresses, :user_id, :integer
  end
end
