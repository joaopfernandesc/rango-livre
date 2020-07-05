class DepositsController < ApplicationController
  def create
    begin
      params.permit(:amount)

      amount = params[:amount]
      Transaction.transaction do
        @user.update(regular_balance: @user[:regular_balance] + amount)
        transaction = Transaction.create(
          amount: amount,
          transaction_type: 0,
          account_type: 0,
          from_CPF: @user[:CPF],
          to_CPF: @user[:CPF],
          scheduled: false,
          responsible_id: @user[:id]
        )

        Rails.logger.info transaction.errors.messages
        raise RangoLivreExceptions::CreateConflict if !transaction.valid?
      end

      render json: { user: @user.json_object }
    rescue JWT::ExpiredSignature
      render json: { error: 'Expired token' }, status: 401
    rescue RangoLivreExceptions::CreateConflict
      render json: { error: 'Conflict'}, status: 409
    rescue RangoLivreExceptions::BadParameters
      render json: {error: 'Bad parameters'}, status: 422
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      render status: 500
    end
  end  
end