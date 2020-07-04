# frozen_string_literal: true

class ApplicationController < ActionController::API
  include RangoLivreExceptions
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, ENV['SECRET_JWT'])
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, ENV['SECRET_JWT'], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        render status: 400
      end
    end
  end

  def logged_in_user
    if decoded_token
      uuid = decoded_token[0]['uuid']
      @user = User.find_by(uuid: uuid)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Unauthorized token' }, status: :unauthorized unless logged_in?
  end
end
