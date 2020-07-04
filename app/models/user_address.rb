# frozen_string_literal: true

class UserAddress < ApplicationRecord
	validates :nickname, :street, :number, :CEP, :city, :uf, presence: true

  def json_object
    {
      nickname: nickname,
      street: street,
      number: number,
      description: description,
      CEP: self.CEP,
      city: city,
      uf: uf
    }
  end
end
