# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  acts_as_paranoid
  before_create :set_uuid
  validates :CPF, :email, uniqueness: true
  validates :name, :CPF, :phone_number, :email, presence: true

  def json_object
    addresses = UserAddress.where(user_id: id).map(&:json_object)

    {
      uuid: uuid,
      email: email,
      CPF: self.CPF,
      name: name,
      phone_number: phone_number,
      addresses: addresses,
      meal_allowance_balance: meal_allowance_balance,
      regular_balance: regular_balance
    }
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.meal_allowance_balance = 0
    self.regular_balance = 0
  end
end
