class TransactionsController < ApplicationController
	def create
		begin
			transaction = Transaction.new(create_transaction_params)
			raise RangoLivreExceptions::BadParameters if (!transaction.valid?) || (params[:scheduled] == true && timestamp.nil?)
			user = User.find_by(CPF: params[:to_CPF])
			raise RangoLivreExceptions::CreateConflict if params[:transaction_type] == 1 && check_if_enough_funds(user)
			Transaction.transaction do
				transaction.save!
				raise RangoLivreExceptions::NotFound if user.nil?
				if params[:transaction_type] == 0
					user.update(amount: user[:amount] + params[:amount].to_f)
				elsif params[:transaction_type] == 1
					user.update(amount: user[:amount] - params[:amount].to_f)
				else
					raise RangoLivreExceptions::BadParameters
				end
				
			end
			
			render json: {transaction.json_object}, status: 201
		rescue RangoLivreExceptions::NotFound
			render json: { error: 'User not found' }, status: 404
		rescue RangoLivreExceptions::CreateConflict
			render json: { error: "Not enough funds" }, status: 409
		rescue RangoLivreExceptions::BadParameters
			render json: { error: 'Bad parameters'}, status: 422
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
			transaction = Transaction.find_by(uuid: params[:id])			

			raise RangoLivreExceptions::NotFound if transaction.nil?
			raise RangoLivreExceptions::Forbidden if (transaction[:from_CPF] != @user[:CPF]) || transaction[:timestamp] >= Time.now.to_i

			transaction.destroy

			render status: 204
		rescue RangoLivreExceptions::Forbidden
			render json: {error: "Forbidden"}, status: 403
		rescue RangoLivreExceptions::NotFound
			render json: {error: "Not found"}, status: 404
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end
	end

	private
	
	def check_if_enough_funds(user)
		if user[:amount] >= params[:amount].to_f
			return true
		else
			return false
		end
	end
	
    
end