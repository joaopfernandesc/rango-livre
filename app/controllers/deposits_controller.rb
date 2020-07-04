class DepositsController < ApplicationController
  def create
    begin
      params.permit(:amount)

      amount = params[:amount]
      Transaction.transaction do
        @user.update(amount: @user[:regular_balance] + amount)
        Transaction.create(
          amount: amount,
          transaction_type: 0,
          account_type: 0,
          from_CPF: @user[:CPF],
          to_CPF: @user[:CPF],
          scheduled: false
        )
      end

      render json: { @user.json_object }
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      render status: 500
    end
  end  
end