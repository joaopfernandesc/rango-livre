# frozen_string_literal: true

class UserAddress < ApplicationRecord
	validates :nickname, :street, :number, :CEP, :city, :uf, presence: true

  def json_object
    {
      nickname: self.nickname,
      street: self.street,
      number: self.number,
      description: self.description,
      CEP: self.CEP,
      city: self.city,
      uf: self.uf
    }
  end
end
