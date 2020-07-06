# frozen_string_literal: true

class Transaction < ApplicationRecord
	acts_as_paranoid
	before_create :set_uuid
	validates :amount, :transaction_type, :account_type, :from_CPF, :to_CPF, presence: true
	enum account_type: { "Mercado Pago": 0, "Mercado Vale": 1 }
	enum transaction_type: { "Crédito": 0, "Débito": 1 }
	after_commit :execute_send_text_message
	require "http"

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
	def execute_send_text_message
		user = User.find_by(id: self.responsible_id)
		if !user.nil?
			content = mount_content(user)
			send_text_message(content, user[:phone_number])
		end
	end
	
	def mount_content(user)
		message = "Olá!\n"
		message += "#{self.transaction_type} em conta "
		message += self.account_type
		message += " no valor de R$ #{amount}"
		if self.scheduled
			message += "\nAgendado para #{Time.at(self.timestamp).strftime("%d/%B/%Y")}"
		end
		message += "\n \nValor atual Mercado Pago: R$ #{user[:regular_balance]}"
		message += "\nValor atual Mercado Vale: R$ #{user[:meal_allowance_balance]}"

		return message
	end
	
	def send_text_message(content, phone_number)
		HTTP.headers("X-API-TOKEN".to_sym => ENV["ZENVIA_TOKEN"]).post("https://api.zenvia.com/v1/channels/whatsapp/messages", :json => {
			from: ENV["ZENVIA_NAME"],
			to: phone_number,
			contents: [
				{
					type: "text",
					text: content
				}
			]
		})
	end
end
