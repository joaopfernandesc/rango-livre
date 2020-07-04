# frozen_string_literal: true

class AddAuthenticationColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :expired_ts, :integer
  end
end
