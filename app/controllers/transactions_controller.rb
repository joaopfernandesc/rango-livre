class TransactionsController < ApplicationController
	def create
		begin
			
		rescue RangoLivreExceptions::UnauthorizedOperation
			render json: { error: 'Unauthorized token' }
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end
	end
	def index
		begin
			raise RangoLivreExceptions::BadParameters if (params[:offset].nil? || params[:limit].nil?)

			transactions = Transaction.where(to_CPF: @user[:CPF])
			total = transactions.count
			transactions = transactions.offset(offset).limit(limit)

			transactions = transactions.each {|x| x.json_object}

			render json: {
				transactions: transactions, 
				total: total,
				limit: limit,
				offset: offset
			}
		rescue RangoLivreExceptions::BadParameters
			render json: { error: 'Bad parameters'}, status: 422
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end	
	end
	def destroy
		begin
			
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end
	end
    
end