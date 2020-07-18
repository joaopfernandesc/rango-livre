# frozen_string_literal: true

class SessionsController < ApplicationController
	before_action :authorized, only: []

  def create
    raise RangoLivreExceptions::BadParameters if params[:email].nil? || params[:password].nil?

    user = User.find_by(email: params[:email])

    raise RangoLivreExceptions::UnauthorizedOperation if user.nil?

    if user.authenticate(params[:password])
      expire_timestamp = (Time.now + 4.hour).to_i
      token = encode_token({ uuid: user[:uuid], exp: expire_timestamp })
    end
    
    render json: { token: token, expire_timestamp: expire_timestamp, user: user.json_object }, status: 200
  rescue RangoLivreExceptions::UnauthorizedOperation
    render json: { error: 'Incorrect user/password combination' }, status: 401
  rescue RangoLivreExceptions::BadParameters
    render json: { error: 'Bad parameters' }, status: 422
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: 'Internal server error' }, status: 500
  end
end
