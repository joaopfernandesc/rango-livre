# frozen_string_literal: true

class Transaction < ApplicationRecord
	acts_as_paranoid
	before_create :set_uuid
	validates :amount, :transaction_type, :account_type, :from_CPF, :to_CPF, :scheduled, presence: true

	def set_uuid
		self.uuid = SecureRandom.uuid
	end

	def json_object
		order = Order.find_by(id: self.order_id)

		if !order.nil?
			order = {
				uuid: order[:uuid],
				restaurant: order[:restaurant]
			}
		end

		from_user = User.find_by(CPF: self.from_CPF)

		if !from_user.nil?
			from_user = {
				uuid: from_user[:uuid],
				name: from_user[:name],
				CPF: from_user[:CPF]
			}
		end

		return {
			uuid: uuid,
			order: order,
			amount: amount,
			transaction_type: transaction_type,
			account_type: account_type,
			from_user: from_user,
			to_CPF: to_CPF,
			scheduled: scheduled,
			timestamp: timestamp
		}
	end
	
	
end
