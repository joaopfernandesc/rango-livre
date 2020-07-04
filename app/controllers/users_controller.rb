# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized, only: [:show]

  def create
    user = User.new(user_create_params)
    address = UserAddress.new(address_create_params)

		conflict_message = ""

    User.transaction do
			unless user.valid?
				Rails.logger.info user.errors.messages.keys
        if user.errors.messages.keys.include?(:email) && user.errors.messages[:email][0] == "has already been taken"
          conflict_message = 'Email already exists'
          raise RangoLivreExceptions::CreateConflict
        elsif user.errors.messages.keys.include?(:CPF) && user.errors.messages[:CPF][0] == "has already been taken"
          conflict_message = 'CPF already exists'
          raise RangoLivreExceptions::CreateConflict
        else
          raise RangoLivreExceptions::BadParameters
        end
			end
			Rails.logger.info "Address #{address}"
			unless address.valid?
				raise RangoLivreExceptions::BadParameters
			end
			user.save!
			address[:user_id] = user[:id]
      address.save!
    end

    render json: user.json_object, status: 201
  rescue RangoLivreExceptions::CreateConflict
    render json: { error: conflict_message }, status: 409
  rescue RangoLivreExceptions::BadParameters
    render json: { error: 'Bad parameters' }, status: 422
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    render status: 500
  end

  def show
  rescue JWT::ExpiredSignature
    render json: { error: 'Expired token' }, status: 401
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
  end

  private

  def user_create_params
    params.permit(%i[email password CPF name phone_number])
  end

	def address_create_params
		params.permit[:addresses]
    params[:addresses][0].permit %i[street number description CEP city uf nickname]
  end
end
